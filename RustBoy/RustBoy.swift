//
//  RustBoy.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 13/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

#if os(OSX)
import AppKit
import CoreRustBoy
import CoreVideo
#endif

internal class RustBoy {

	internal enum ButtonType {
		case left, right, up, down, a, b, start, select
	}

    internal struct Cartridge: Equatable {
		internal let path: String
		internal let saveFilePath: String
	}

	internal enum BootStatus: Error {
        case cartridgeMissing
		case failedToInitCore
		case success
	}

	internal var cartridge: Cartridge? {
		didSet {
            guard cartridge != nil else {
#if os(OSX)
                coreRustBoy = nil
#endif
                return
            }

            if autoBoot {
                let _ = boot()
            }
		}
	}

    internal var autoBoot = false

    internal var display: DisplayView? {
        didSet {
#if os(OSX)
            coreRustBoy?.display = display
#endif
        }
    }

    internal required init() {}

    internal func buttonDown(_ button: ButtonType) {
#if os(OSX)
        coreRustBoy?.buttonDown(rustBoyButton(button))
#endif
    }

	internal func buttonUp(_ button: ButtonType) {
#if os(OSX)
        coreRustBoy?.buttonUp(rustBoyButton(button))
#endif
    }

	internal func boot() -> BootStatus {
		guard let cart = cartridge else { return .cartridgeMissing }
#if os(OSX)
        guard let coreRustBoy = CoreRustBoy(cartridge: cart) else { return .failedToInitCore }

        self.coreRustBoy = coreRustBoy
        self.coreRustBoy?.display = display
#endif

		return .success
	}

#if os(OSX)
    private var coreRustBoy: CoreRustBoy?
#endif
}

#if os(OSX)
fileprivate class CoreRustBoy {

    fileprivate weak var display: DisplayView?

    fileprivate init?(cartridge: RustBoy.Cartridge) {
        guard let coreRef = rustBoyCreate(cartridge.path, cartridge.saveFilePath) else { return nil }
        self.coreRef = coreRef
        timer = Timer.scheduledTimer(withTimeInterval: 1 / Self.framerate, repeats: true) { timer in
            self.render()
        }
    }

    fileprivate func buttonDown(_ button: rustBoyButton) {
        rustBoyButtonClickDown(coreRef, button)
    }

    fileprivate func buttonUp(_ button: rustBoyButton) {
        rustBoyButtonClickUp(coreRef, button)
    }

    private func render() {
        rustBoyFrame(coreRef, &buffer, UInt32(buffer.count))

        guard let display = display else { return }

        let data = Data(bytes: &buffer, count: buffer.count)
        let dataProvider = CGDataProvider(data: data as CFData)!
        let colorSpace = CGColorSpace(name: CGColorSpace.sRGB)!

        let coreImage = CGImage(
            width:              160,
            height:             144,
            bitsPerComponent:   8,
            bitsPerPixel:       32,
            bytesPerRow:        640,
            space:              colorSpace,
            bitmapInfo:         [CGBitmapInfo.byteOrder32Big, CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue)],
            provider:           dataProvider,
            decode:             nil,
            shouldInterpolate:  false,
            intent:             CGColorRenderingIntent.saturation
        )

        let image = NSImage(cgImage: coreImage!, size: NSSize(width: 160, height: 144))
        display.image = image
    }

    deinit {
        timer?.invalidate()
        rustBoyDelete(coreRef)
    }

    private let coreRef: UnsafeRawPointer
    private var timer: Timer?
    private var buffer = [UInt32](repeating: 0, count: 144 * 640)
    private static let framerate: Double = 60
}
#endif

#if os(OSX)
    private extension rustBoyButton {
        init(_ buttonType: RustBoy.ButtonType) {
            switch buttonType {
                case .left:     self = rustBoyButtonLeft
                case .right:    self = rustBoyButtonRight
                case .up:       self = rustBoyButtonUp
                case .down:     self = rustBoyButtonDown
                case .a:        self = rustBoyButtonA
                case .b:        self = rustBoyButtonB
                case .start:    self = rustBoyButtonStart
                case .select:   self = rustBoyButtonSelect
            }
        }
    }
#endif
