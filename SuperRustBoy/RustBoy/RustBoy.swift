//
//  RustBoy.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/07/2020.
//

import CoreGraphics
import CoreRustBoy
import Foundation

internal final class RustBoy: BaseEmulator<CoreRustBoy> {
    internal enum Button {
        case left, right, up, down, a, b, start, select
    }

    internal struct Cartridge {
        internal let path: String
        internal let saveFilePath: String
    }
}

internal final class CoreRustBoy: CoreEmulator {

    static let sampleRate: Float = 44100

    internal required init?(cartridge: RustBoy.Cartridge, sampleRate: UInt32) {
        guard let coreRef = rustBoyCreate(cartridge.path, cartridge.saveFilePath) else { return nil }
        self.coreRef = coreRef
        self.audioHandle = AudioHandle(coreRustBoyRef: coreRef, sampleRate: sampleRate)
    }

    deinit {
        rustBoyDelete(coreRef)
    }

    internal func buttonPressed(_ button: RustBoy.Button, playerIndex: PlayerIndices.OnePlayer) {
        rustBoyButtonClickDown(coreRef, rustBoyButton(button))
    }

    internal func buttonUnpressed(_ button: RustBoy.Button, playerIndex: PlayerIndices.OnePlayer) {
        rustBoyButtonClickUp(coreRef, rustBoyButton(button))
    }

    internal func render() -> CGImage? {
        rustBoyFrame(coreRef, &buffer, UInt32(buffer.count))

        let data = Data(bytes: &buffer, count: buffer.count)

        return Self.createCGImage(from: data)
    }

    internal func getAudioPacket(buffer: inout [Float]) {
        audioHandle.getAudioPacket(buffer: &buffer)
    }

    private let coreRef: UnsafeRawPointer
    private var buffer = [UInt8](repeating: 0, count: Int(frameBufferSize))

    private let audioHandle: AudioHandle

    private static let frameInfo = rustBoyGetFrameInfo()
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

private final class AudioHandle {

    fileprivate init(coreRustBoyRef: UnsafeRawPointer, sampleRate: UInt32) {
        coreAudioHandleRef = rustBoyGetAudioHandle(coreRustBoyRef, sampleRate)
    }

    deinit {
        rustBoyDeleteAudioHandle(coreAudioHandleRef)
    }

    fileprivate func getAudioPacket(buffer: inout [Float]) {
        rustBoyGetAudioPacket(coreAudioHandleRef, &buffer, UInt32(buffer.count))
    }

    private let coreAudioHandleRef: UnsafeRawPointer
}

private extension rustBoyButton {
    init(_ buttonType: RustBoy.Button) {
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
