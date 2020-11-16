//
//  Display.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 22/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

#if os(OSX)
internal typealias ImageView = NSImageView
#else
internal typealias ImageView = UIImageView
#endif

internal class DisplayView: ImageView {}

internal struct Display {
    internal let emulator: Emulator

    fileprivate func createDisplayView() -> DisplayView {
        DisplayView.setup {
#if os(OSX)
            $0.wantsLayer = true
            $0.layer?.backgroundColor = NSColor.black.cgColor
#else
            $0.contentMode = .scaleToFill
            $0.backgroundColor = Self.backgroundColor
#endif
            emulator.display = $0
        }
    }

#if os(iOS) || os(tvOS)
    private static let backgroundColor = UIColor { traitCollection -> UIColor in
        switch traitCollection.userInterfaceStyle {
        case .dark:
            return .white
        case .light, .unspecified:
            return .black
        @unknown default:
            return .black
        }
    }
#endif
}

extension DisplayView: EmulatorDisplay {
    func setCGImage(_ image: CGImage) {
#if os(OSX)
        self.image = NSImage(cgImage: image, size: .init(width: 400, height: 300))
#else
        self.image = UIImage(cgImage: image)
#endif
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
	internal func updateUIView(_ uiView: DisplayView, context: Context) { emulator.display = uiView }
}
#endif

