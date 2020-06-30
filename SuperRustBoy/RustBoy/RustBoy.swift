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
import AVFoundation

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
        speaker?.delegate = coreRustBoy.audioHandle

        return .success
    }

    private let speaker = Speaker(sampleRate: Float64(AudioHandle.sampleRate))
    private var coreRustBoy: CoreRustBoy?
}


private final class CoreRustBoy {

    fileprivate weak var display: DisplayView?
    fileprivate let audioHandle: AudioHandle

    fileprivate init?(cartridge: RustBoy.Cartridge) {
        guard let coreRef = rustBoyCreate(cartridge.path, cartridge.saveFilePath) else { return nil }
        self.coreRef = coreRef
        audioHandle = AudioHandle(coreRustBoyRef: coreRef)
        timer = Timer.scheduledTimer(withTimeInterval: 1 / Self.framerate, repeats: true) { [weak self] timer in
            self?.render()
        }
    }

    deinit {
        timer?.invalidate()
        rustBoyDelete(coreRef)
    }

    fileprivate func buttonPressed(_ button: rustBoyButton) {
        rustBoyButtonClickDown(coreRef, button)
    }

    fileprivate func buttonUnpressed(_ button: rustBoyButton) {
        rustBoyButtonClickUp(coreRef, button)
    }

    private let coreRef: UnsafeRawPointer

    private var timer: Timer?
    private var buffer = [UInt8](repeating: 0, count: Int(frameBufferSize))

    private static let framerate: Double = 60
    private static let frameInfo = rustBoyGetFrameInfo()
    private static var frameBufferSize: UInt32 {
        frameInfo.width * frameInfo.height * frameInfo.bytesPerPixel
    }
    private static let bitsPerByte = 8

    private func render() {
        rustBoyFrame(coreRef, &buffer, UInt32(buffer.count))

        guard let display = display else { return }

        let data = Data(bytes: &buffer, count: buffer.count)

        guard let coreImage = Self.createCGImage(from: data) else { return }

#if os(OSX)
        let image = NSImage(cgImage: coreImage, size: NSSize(width: Int(Self.frameInfo.width), height: Int(Self.frameInfo.height)))
#else
        let image = UIImage(cgImage: coreImage)
#endif

        display.image = image
    }

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

#if os(OSX)
    fileprivate static let sampleRate = UInt32(44100)
#else
    fileprivate static let sampleRate = UInt32(AVAudioSession.sharedInstance().sampleRate)
#endif

    fileprivate init(coreRustBoyRef: UnsafeRawPointer) {
        coreAudioHandleRef = rustBoyGetAudioHandle(coreRustBoyRef, Self.sampleRate)
    }

    deinit {
        rustBoyDeleteAudioHandle(coreAudioHandleRef)
    }

    fileprivate func getAudioPacket(buffer: inout [Float]) {
        rustBoyGetAudioPacket(coreAudioHandleRef, &buffer, UInt32(buffer.count))
    }

    private let coreAudioHandleRef: UnsafeRawPointer
}

extension AudioHandle: SpeakerDelegate {
    func speaker(_ speaker: Speaker, requestsData data: inout [Float]) {
        getAudioPacket(buffer: &data)
    }
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

