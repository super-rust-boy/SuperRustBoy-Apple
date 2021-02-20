//
//  GBA.swift
//  macOS
//
//  Created by Sean Inge Asbjørnsen on 20/02/2021.
//

import CoreGBA
import CoreGraphics

internal final class GBA: BaseEmulator<CoreGBA> {
    internal enum Button {
        case left, right, up, down, a, b, start, select, L, R
    }

    internal struct Cartridge {
        internal let path: String
    }
}

internal final class CoreGBA: CoreEmulator {

    internal required init?(cartridge: GBA.Cartridge, sampleRate: UInt32) {
        guard let coreRef = gbaCreate(cartridge.path) else { return nil }
        self.coreRef = coreRef
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

    func render() -> CGImage? { nil }
    func getAudioPacket(buffer: inout [Float]) {}

    private let coreRef: UnsafeRawPointer
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
