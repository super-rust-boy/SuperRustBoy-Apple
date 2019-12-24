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

	private let rustBoy = RustBoy()

	func applicationDidFinishLaunching(_ aNotification: Notification) {

		guard let stringPath = Bundle.main.path(forResource: "PokemonRed", ofType: "gb") else {
			assertionFailure("Failed to find file")
			return
		}

		let cartPath = "file://" + stringPath

		rustBoy.cartridgePath = cartPath
		rustBoy.saveFilePath = ""

		// Create the SwiftUI view that provides the window contents.
		let rootView = RustBoyView(rustBoy: rustBoy)

		// Create the window and set the content view.
		window = NSWindow(
		    contentRect:	NSRect(x: 0, y: 0, width: 300, height: 600),
		    styleMask:		[.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
		    backing:		.buffered,
			defer:			false
		)
		window.center()
		window.setFrameAutosaveName("Main Window")
		window.contentView = NSHostingView(rootView: rootView)
		window.makeKeyAndOrderFront(nil)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}

}

