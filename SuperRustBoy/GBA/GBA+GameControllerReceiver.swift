//
//  GBA+GameControllerReceiver.swift
//  macOS
//
//  Created by Sean Inge Asbjørnsen on 20/02/2021.
//

extension GBA: GameControllerReceiver {
    func buttonPressed(_ button: GameControllerButton, playerIndex: PlayerIndices.FourPlayer) {
        if let button = GBA.Button(button), let playerIndex = PlayerIndices.OnePlayer(playerIndex) {
            buttonPressed(button, playerIndex: playerIndex)
        }
    }

    func buttonUnpressed(_ button: GameControllerButton, playerIndex: PlayerIndices.FourPlayer) {
        if let button = GBA.Button(button), let playerIndex = PlayerIndices.OnePlayer(playerIndex) {
            buttonUnpressed(button, playerIndex: playerIndex)
        }
    }
}

private extension GBA.Button {
    init?(_ button: GameControllerButton) {
        switch button {
        case .left:          self = .left
        case .up:            self = .up
        case .right:         self = .right
        case .down:          self = .down
        case .a:             self = .a
        case .b:             self = .b
        case .options:       self = .select
        case .menu:          self = .start

        case .x:             return nil
        case .y:             return nil

        case .leftShoulder:  self = .L
        case .rightShoulder: self = .R
        }
    }
}
