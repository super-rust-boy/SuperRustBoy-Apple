//
//  SNES+KeyboardReceiver.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 09/09/2020.
//

import GameController

extension SNES: KeyboardReceiver {
    func buttonPressed(_ button: GCKeyCode, playerIndex: PlayerIndices.FourPlayer) {
        if let button = SNES.Button(button), let playerIndex = PlayerIndices.TwoPlayer(playerIndex) {
            buttonPressed(button, playerIndex: playerIndex)
        }
    }

    func buttonUnpressed(_ button: GCKeyCode, playerIndex: PlayerIndices.FourPlayer) {
        if let button = SNES.Button(button), let playerIndex = PlayerIndices.TwoPlayer(playerIndex) {
            buttonUnpressed(button, playerIndex: playerIndex)
        }
    }
}

private extension SNES.Button {
    init?(_ button: GCKeyCode) {
        switch button {
        case .leftArrow:     self = .left
        case .upArrow:       self = .up
        case .rightArrow:    self = .right
        case .downArrow:     self = .down

        case .keyA:          self = .y
        case .keyW:          self = .x
        case .keyS:          self = .a
        case .keyZ:          self = .b

        case .returnOrEnter: self = .start
        case .spacebar:      self = .select

        default: return nil
        }
    }
}
