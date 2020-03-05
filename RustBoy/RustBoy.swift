//
//  RustBoy.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 13/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

#if os(OSX)
import AppKit
#else
import UIKit
#endif
import CoreRustBoy
import CoreVideo

internal final class RustBoy {

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
            coreRustBoy = nil

            if autoBoot {
                let _ = boot()
            }
        }
    }

    internal var autoBoot = false

    internal var display: DisplayView? {
        didSet {
            coreRustBoy?.display = display
        }
    }

    internal required init() {}

    internal func buttonPressed(_ button: ButtonType) {
        coreRustBoy?.buttonPressed(rustBoyButton(button))
    }

    internal func buttonUnpressed(_ button: ButtonType) {
        coreRustBoy?.buttonUnpressed(rustBoyButton(button))
    }

    internal func boot() -> BootStatus {
        guard let cart = cartridge else { return .cartridgeMissing }

        guard let coreRustBoy = CoreRustBoy(cartridge: cart) else { return .failedToInitCore }

        self.coreRustBoy = coreRustBoy
        self.coreRustBoy?.display = display

        return .success
    }

    private var coreRustBoy: CoreRustBoy?

}


fileprivate final class CoreRustBoy {

    fileprivate weak var display: DisplayView?

    fileprivate init?(cartridge: RustBoy.Cartridge) {
        guard let coreRef = rustBoyCreate(cartridge.path, cartridge.saveFilePath) else { return nil }
        self.coreRef = coreRef
        timer = Timer.scheduledTimer(withTimeInterval: 1 / Self.framerate, repeats: true) { [weak self] timer in
            self?.render()
        }
    }

    fileprivate func buttonPressed(_ button: rustBoyButton) {
        rustBoyButtonClickDown(coreRef, button)
    }

    fileprivate func buttonUnpressed(_ button: rustBoyButton) {
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

#if os(OSX)
        let image = NSImage(cgImage: coreImage!, size: NSSize(width: 160, height: 144))
#else
        let image = UIImage(cgImage: coreImage!)
#endif

        display.image = image
    }

    deinit {
        timer?.invalidate()
        rustBoyDelete(coreRef)
    }

    private let coreRef: UnsafeRawPointer
    private var timer: Timer?
    private var buffer = [UInt8](repeating: 0, count: Int(rustBoyGetFrameSize()))
    private static let framerate: Double = 60
}

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

