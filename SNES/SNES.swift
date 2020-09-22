//
//  SNES.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/07/2020.
//  Copyright © 2020 Sean Inge Asbjørnsen. All rights reserved.
//

import CoreGraphics
import CoreSNES
import Foundation

internal final class SNES: BaseEmulator<CoreSNES> {
    internal enum Button {
        case left, right, up, down, a, b, x, y, start, select, leftShoulder, rightShoulder
    }

    internal struct Cartridge {
        internal let path: String
        internal let saveFilePath: String
    }
}

internal final class CoreSNES: CoreEmulator {
    static var sampleRate: Float = 44100

    internal required init?(cartridge: SNES.Cartridge, sampleRate: UInt32) {
        guard let coreRef = snesCreate(cartridge.path, cartridge.saveFilePath) else { return nil }
        self.coreRef = coreRef
    }

    deinit {
        snesDelete(coreRef)
    }

    internal func buttonPressed(_ button: SNES.Button, playerIndex: PlayerIndices.TwoPlayer) {
        snesButtonClickDown(coreRef, snesButton(button), playerIndex.rawValue)
    }

    internal func buttonUnpressed(_ button: SNES.Button, playerIndex: PlayerIndices.TwoPlayer) {
        snesButtonClickUp(coreRef, snesButton(button), playerIndex.rawValue)
    }

    internal func render() -> CGImage? {
        snesFrame(coreRef, &buffer, UInt32(buffer.count))

        let data = Data(bytes: &buffer, count: buffer.count)

        return Self.createCGImage(from: data)
    }

    internal func getAudioPacket(buffer: inout [Float]) {
        // TODO
    }

    private let coreRef: UnsafeRawPointer
    private var buffer = [UInt8](repeating: 0, count: Int(frameBufferSize))
    private static let frameInfo = snesGetFrameInfo()
    private static let frameBufferSize: UInt32 = frameInfo.width * frameInfo.height * frameInfo.bytesPerPixel

    private static let bitsPerByte = 8

    private static func createCGImage(from data: Data) -> CGImage? {
        guard let dataProvider = CGDataProvider(data: data as CFData) else { return nil }
        guard let colorSpace = CGColorSpace(name: CGColorSpace.sRGB) else { return nil }

        return CGImage(
            width:              Int(frameInfo.width),
            height:             Int(frameInfo.height),
            bitsPerComponent:   8,
            bitsPerPixel:       Int(frameInfo.bytesPerPixel) * bitsPerByte,
            bytesPerRow:        Int(frameInfo.width * frameInfo.bytesPerPixel),
            space:              colorSpace,
            bitmapInfo:         [CGBitmapInfo.byteOrder32Big, CGBitmapInfo(rawValue: CGImageAlphaInfo.noneSkipLast.rawValue)],
            provider:           dataProvider,
            decode:             nil,
            shouldInterpolate:  false,
            intent:             CGColorRenderingIntent.saturation
        )
    }
}

private extension snesButton {
    init(_ buttonType: SNES.Button) {
        switch buttonType {
            case .left:          self = snesButtonLeft
            case .right:         self = snesButtonRight
            case .up:            self = snesButtonUp
            case .down:          self = snesButtonDown
            case .a:             self = snesButtonA
            case .b:             self = snesButtonB
            case .x:             self = snesButtonX
            case .y:             self = snesButtonY
            case .start:         self = snesButtonStart
            case .select:        self = snesButtonSelect
            case .leftShoulder:  self = snesButtonL
            case .rightShoulder: self = snesButtonR
        }
    }
}


