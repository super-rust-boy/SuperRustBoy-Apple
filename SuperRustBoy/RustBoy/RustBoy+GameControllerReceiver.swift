//
//  RustBoy+GameControllerReceiver.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 02/09/2020.
//

extension RustBoy: GameControllerReceiver {
    func buttonPressed(_ button: GameControllerButton, playerIndex: Int) {
        if let button = RustBoy.Button(button), let playerIndex = PlayerIndices.OnePlayer(rawValue: playerIndex) {
            buttonPressed(button, playerIndex: playerIndex)
        }
    }

    func buttonUnpressed(_ button: GameControllerButton, playerIndex: Int) {
        if let button = RustBoy.Button(button), let playerIndex = PlayerIndices.OnePlayer(rawValue: playerIndex) {
            buttonUnpressed(button, playerIndex: playerIndex)
        }
    }
}

private extension RustBoy.Button {
    init?(_ button: GameControllerButton) {
        switch button {
        case .left:         self = .left
        case .up:           self = .up
        case .right:        self = .right
        case .down:         self = .down
        case .a:            self = .a
        case .b:            self = .b
        case .options:      self = .select
        case .menu:         self = .start

        case .x:            return nil
        case .y:            return nil

        case .leftShoulder: return nil
        case .rightShoulder:return nil
        }
    }
}
