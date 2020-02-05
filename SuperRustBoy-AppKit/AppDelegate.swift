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

		let cartPath = NSHomeDirectory() + "/Roms/PokemonRed.gb"
        let savePath = NSHomeDirectory() + "/Roms/SaveFiles/PokemonRed.sav"

        rustBoy.cartridge = RustBoy.Cartridge(path: cartPath, saveFilePath: savePath)

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

