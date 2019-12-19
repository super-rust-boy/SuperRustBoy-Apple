//
//  AppDelegate.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 13/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

	var window: NSWindow!

	private lazy var rustBoy: RustBoy? = {

		guard let stringPath = Bundle.main.path(forResource: "PokemonRed", ofType: "gb") else {
			assertionFailure("Failed to find file")
			return nil
		}

		return RustBoy(cartridgePath: "file://" + stringPath, saveFilePath: "")
	}()

	func applicationDidFinishLaunching(_ aNotification: Notification) {

		// Create the SwiftUI view that provides the window contents.
		let contentView = ContentView()

		// Create the window and set the content view.
		window = NSWindow(
		    contentRect:	NSRect(x: 0, y: 0, width: 300, height: 600),
		    styleMask:		[.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
		    backing:		.buffered,
			defer:			false
		)
		window.center()
		window.setFrameAutosaveName("Main Window")
		window.contentView = NSHostingView(rootView: contentView)
		window.makeKeyAndOrderFront(nil)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}

