//
//  RustBoy+KeyboardReceiver.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 09/09/2020.
//

import GameController

extension RustBoy: KeyboardReceiver {
    func buttonPressed(_ button: GCKeyCode) {
        if let button = RustBoy.Button(button) {
            buttonPressed(button, playerIndex: .playerOne)
        }
    }

    func buttonUnpressed(_ button: GCKeyCode) {
        if let button = RustBoy.Button(button) {
            buttonUnpressed(button)
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
