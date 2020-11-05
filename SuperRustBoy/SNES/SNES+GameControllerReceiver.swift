//
//  SNES+GameControllerReceiver.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 02/09/2020.
//

extension SNES: GameControllerReceiver {
    func buttonPressed(_ button: GameControllerButton, playerIndex: PlayerIndices.FourPlayer) {
        if let playerIndex = PlayerIndices.TwoPlayer(playerIndex) {
            buttonPressed(SNES.Button(button), playerIndex: playerIndex)
        }
    }

    func buttonUnpressed(_ button: GameControllerButton, playerIndex: PlayerIndices.FourPlayer) {
        if let playerIndex = PlayerIndices.TwoPlayer(playerIndex) {
            buttonUnpressed(SNES.Button(button), playerIndex: playerIndex)
        }
    }
}

private extension SNES.Button {
    init(_ button: GameControllerButton) {
        switch button {
        case .left:             self = .left
        case .up:               self = .up
        case .right:            self = .right
        case .down:             self = .down
        case .a:                self = .b
        case .b:                self = .a
        case .x:                self = .y
        case .y:                self = .x
        case .options:          self = .select
        case .menu:             self = .start
        case .leftShoulder:     self = .leftShoulder
        case .rightShoulder:    self = .rightShoulder
        }
    }
}
