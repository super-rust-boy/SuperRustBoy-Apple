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

	func applicationDidFinishLaunching(_ aNotification: Notification) {

		// Testing RustBoy
		guard let stringPath = Bundle.main.path(forResource: "PokemonRed", ofType: "gb") else {
			assertionFailure("Failed to find file")
			return
		}
		let rustBoy = RustBoy(cartridgePath: "file://" + stringPath, saveFilePath: "")

		// Create the SwiftUI view that provides the window contents.
		let contentView = ContentView()

		// Create the window and set the content view. 
		window = NSWindow(
		    contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
		    styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
		    backing: .buffered, defer: false)
		window.center()
		window.setFrameAutosaveName("Main Window")
		window.contentView = NSHostingView(rootView: contentView)
		window.makeKeyAndOrderFront(nil)
	}

	func applicationWillTerminate(_ aNotification: Notification) {
		// Insert code here to tear down your application
	}


}

