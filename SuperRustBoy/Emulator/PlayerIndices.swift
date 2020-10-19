//
//  PlayerIndices.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/07/2020.
//

enum PlayerIndices {}

extension PlayerIndices {
    enum OnePlayer: Int, RawRepresentable {
        case playerOne

        init?(rawValue: Int) {
            switch rawValue {
            case 1:
                self = .playerOne
            default:
                return nil
            }
        }
    }

    enum TwoPlayer: Int, RawRepresentable {
        case playerOne, playerTwo

        init?(rawValue: Int) {
            switch rawValue {
            case 1:
                self = .playerOne

            case 2:
                self = .playerTwo

            default:
                return nil
            }
        }
    }
}
