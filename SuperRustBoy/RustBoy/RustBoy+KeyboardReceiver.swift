//
//  RustBoy+KeyboardReceiver.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 09/09/2020.
//

import GameController

extension RustBoy: KeyboardReceiver {
    func buttonPressed(_ button: GCKeyCode, playerIndex: PlayerIndices.FourPlayer) {
        if let button = RustBoy.Button(button), let playerIndex = PlayerIndices.OnePlayer(playerIndex) {
            buttonPressed(button, playerIndex: playerIndex)
        }
    }

    func buttonUnpressed(_ button: GCKeyCode, playerIndex: PlayerIndices.FourPlayer) {
        if let button = RustBoy.Button(button), let playerIndex = PlayerIndices.OnePlayer(playerIndex) {
            buttonUnpressed(button, playerIndex: playerIndex)
        }
    }
}

private extension RustBoy.Button {
    init?(_ button: GCKeyCode) {
        switch button {
        case .leftArrow:     self = .left
        case .upArrow:       self = .up
        case .rightArrow:    self = .right
        case .downArrow:     self = .down

        case .keyA:          self = .a
        case .keyS:          self = .b

        case .returnOrEnter: self = .start
        case .spacebar:      self = .select

        default: return nil
        }
    }
}
