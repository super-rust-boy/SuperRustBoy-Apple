//
//  Emulator.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 29/07/2020.
//

import Foundation
import CoreGraphics

internal protocol EmulatorDisplay: AnyObject {
    var imageData: CGImage? { get set }
}

internal protocol Emulator: AnyObject {
    var display: EmulatorDisplay? { get set }
}

internal protocol CoreEmulator {
    associatedtype Cartridge
    associatedtype Button
    associatedtype PlayerIndexType

    init?(cartridge: Cartridge, sampleRate: UInt32)

    func buttonPressed(_ button: Button, playerIndex: PlayerIndexType)
    func buttonUnpressed(_ button: Button, playerIndex: PlayerIndexType)

    func render() -> CGImage?
    func getAudioPacket(buffer: inout [Float])
}

internal enum BootStatus: Error {
    case cartridgeMissing
    case failedToInitCore
    case success
}

internal class BaseEmulator<CoreEmu>: Emulator where CoreEmu: CoreEmulator {
    internal final var cartridge: CoreEmu.Cartridge? {
        didSet {
            coreEmulator = nil

            if autoBoot {
                let _ = boot()
            }
        }
    }

    internal final var autoBoot = false

    internal weak final var display: EmulatorDisplay?

    internal init() {
        timer = Timer.scheduledTimer(withTimeInterval: 1 / framerate, repeats: true) { [weak self] timer in
            guard let display = self?.display else { return }
            display.imageData = self?.coreEmulator?.render()
        }
    }

    internal final func boot() -> BootStatus {
        guard let cart = cartridge else { return .cartridgeMissing }

        guard let coreEmulator = CoreEmu(cartridge: cart, sampleRate: sampleRate) else { return .failedToInitCore }

        self.coreEmulator = coreEmulator
        let delegate = InternalSpeakerDelegate(coreEmulator: coreEmulator)
        self.speaker?.delegate = delegate
        self.speakerDelegate = delegate

        return .success
    }

    internal final func buttonPressed(_ button: CoreEmu.Button, playerIndex: CoreEmu.PlayerIndexType) {
        coreEmulator?.buttonPressed(button, playerIndex: playerIndex)
    }

    internal final func buttonUnpressed(_ button: CoreEmu.Button, playerIndex: CoreEmu.PlayerIndexType) {
        coreEmulator?.buttonUnpressed(button, playerIndex: playerIndex)
    }

    private var coreEmulator: CoreEmu?
    private let speaker = Speaker(sampleRate: Float64(sampleRate))
    private var speakerDelegate: InternalSpeakerDelegate?
    private var timer: Timer?

    private class InternalSpeakerDelegate: SpeakerDelegate {

        init(coreEmulator: CoreEmu) {
            self.coreEmulator = coreEmulator
        }

        func speaker(_ speaker: Speaker, requestsData data: inout [Float]) {
            self.coreEmulator.getAudioPacket(buffer: &data)
        }

        private let coreEmulator: CoreEmu
    }
}

extension BaseEmulator where CoreEmu.PlayerIndexType == PlayerIndices.OnePlayer {
    func buttonPressed(_ button: CoreEmu.Button) {
        buttonPressed(button, playerIndex: .playerOne)
    }

    func buttonUnpressed(_ button: CoreEmu.Button) {
        buttonUnpressed(button, playerIndex: .playerOne)
    }
}

private let framerate: Double = 60
private let sampleRate: UInt32 = 44100
