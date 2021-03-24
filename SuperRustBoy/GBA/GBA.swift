//
//  GBA.swift
//  macOS
//
//  Created by Sean Inge Asbjørnsen on 20/02/2021.
//

import CoreGBA
import CoreGraphics
import Foundation

internal final class GBA: BaseEmulator<CoreGBA> {
    internal enum Button {
        case left, right, up, down, a, b, start, select, L, R
    }

    internal struct Cartridge {
        internal let path: String
        internal let biosPath: String
    }
}

internal final class CoreGBA: CoreEmulator {

    internal required init?(cartridge: GBA.Cartridge, sampleRate: UInt32) {
        guard let coreRef = gbaCreate(cartridge.biosPath, cartridge.path) else { return nil }
        self.coreRef = coreRef
        self.frameInfo = gbaFetchRenderSize(coreRef)
    }

    deinit {
        gbaDelete(coreRef)
    }

    internal func buttonPressed(_ button: GBA.Button, playerIndex: PlayerIndices.OnePlayer) {
        gbaButtonSetPressed(coreRef, gbaButton(button), true)
    }

    internal func buttonUnpressed(_ button: GBA.Button, playerIndex: PlayerIndices.OnePlayer) {
        gbaButtonSetPressed(coreRef, gbaButton(button), false)
    }

    func render() -> CGImage? {
        gbaFrame(coreRef, &buffer, UInt32(buffer.count))

        let data = Data(bytes: &buffer, count: buffer.count)

        return createCGImage(from: data)
    }

    func getAudioPacket(buffer: inout [Float]) {}

    private let coreRef: UnsafeRawPointer
    private lazy var buffer = [UInt8](repeating: 0, count: Int(frameBufferSize))

    private let frameInfo: gbaRenderSize

    private var frameBufferSize: UInt32 {
        frameInfo.width * frameInfo.height * Self.bytesPerPixel
    }

    private static let bitsPerByte: UInt32 = 8
    private static let bytesPerPixel: UInt32 = 4

    private func createCGImage(from data: Data) -> CGImage? {
        guard let dataProvider = CGDataProvider(data: data as CFData) else { return nil }
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }

        return CGImage(
            width:              Int(frameInfo.width),
            height:             Int(frameInfo.height),
            bitsPerComponent:   8,
            bitsPerPixel:       Int(Self.bytesPerPixel * Self.bitsPerByte),
            bytesPerRow:        Int(frameInfo.width * Self.bytesPerPixel),
            space:              colorSpace,
            bitmapInfo:         [CGBitmapInfo.byteOrder32Big, CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue)],
            provider:           dataProvider,
            decode:             nil,
            shouldInterpolate:  false,
            intent:             CGColorRenderingIntent.saturation
        )
    }
}

private extension gbaButton {
    init(_ buttonType: GBA.Button) {
        switch buttonType {
            case .left:     self = gbaButtonLeft
            case .right:    self = gbaButtonRight
            case .up:       self = gbaButtonUp
            case .down:     self = gbaButtonDown
            case .a:        self = gbaButtonA
            case .b:        self = gbaButtonB
            case .start:    self = gbaButtonStart
            case .select:   self = gbaButtonSelect
            case .L:        self = gbaButtonL
            case .R:        self = gbaButtonR
        }
    }
}
