//
//  PlayerIndices.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/07/2020.
//

import Foundation

enum PlayerIndices {}

extension PlayerIndices {
    enum OnePlayer: UInt32 {
        case playerOne
    }

    enum TwoPlayer: UInt32 {
        case playerOne, playerTwo
    }
}
