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
	override class var layerClass: AnyClass { CAMetalLayer.self }
}

internal struct Display: UIViewRepresentable {

	internal func makeUIView(context: Context) -> DisplayView {
		return DisplayView()
	}

	internal func updateUIView(_ uiView: DisplayView, context: Context) {

	}
}
