//
//  Display.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 22/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

#if os(OSX)
internal typealias ViewType = NSView
#else
internal typealias ViewType = UIView
#endif

internal class DisplayView: ViewType {
#if os(OSX)
	// TODO: Use CAMetalLayer as backing layer for NSView
#else
	override class var layerClass: AnyClass { CAMetalLayer.self }
#endif
}

#if os(OSX)
internal struct Display: NSViewRepresentable {

	internal let rustBoy: RustBoy

    internal func makeNSView(context: Context) -> DisplayView {
		DisplayView().apply { (view: DisplayView) in
			rustBoy.display = view
		}
    }

    internal func updateNSView(_ nsView: DisplayView, context: Context) {

    }
}
#else
internal struct Display: UIViewRepresentable {

	internal func makeUIView(context: Context) -> DisplayView {
		DisplayView()
	}

	internal func updateUIView(_ uiView: DisplayView, context: Context) {

	}
}
#endif

