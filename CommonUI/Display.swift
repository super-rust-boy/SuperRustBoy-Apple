//
//  Display.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 22/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

#if os(OSX)
internal typealias ViewType = NSImageView
#else
internal typealias ViewType = UIImageView
#endif

internal class DisplayView: ViewType {}

internal struct Display {
    internal let rustBoy: RustBoy

    fileprivate func createDisplayView() -> DisplayView {
        DisplayView().apply {
#if os(OSX)
            $0.wantsLayer = true
            $0.layer?.backgroundColor = NSColor.black.cgColor
#endif

            rustBoy.display = $0
        }
    }
}

#if os(OSX)
extension Display: NSViewRepresentable {
    internal func makeNSView(context: Context) -> DisplayView { createDisplayView() }
    internal func updateNSView(_ nsView: DisplayView, context: Context) {}
}
#else
extension Display: UIViewRepresentable {
	internal func makeUIView(context: Context) -> DisplayView { createDisplayView() }
	internal func updateUIView(_ uiView: DisplayView, context: Context) {}
}
#endif

