//
//  PlayerIndices.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/07/2020.
//

enum PlayerIndices {}

extension PlayerIndices {
    enum OnePlayer: Int {
        case player1
    }

    enum TwoPlayer: Int {
        case player1, player2
    }

    enum FourPlayer: Int {
        case player1, player2, player3, player4
    }
}

extension PlayerIndices.OnePlayer {
    init?(_ index: PlayerIndices.FourPlayer) {
        switch index {
        case .player1:
            self = .player1

        case .player2, .player3, .player4:
            return nil
        }
    }
}

extension PlayerIndices.TwoPlayer {
    init?(_ index: PlayerIndices.FourPlayer) {
        switch index {
        case .player1:
            self = .player1

        case .player2:
            self = .player2

        case .player3, .player4:
            return nil
        }
    }
}
