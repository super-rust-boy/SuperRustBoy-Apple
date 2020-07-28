//
//  GameControllerIndicator.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 14/07/2020.
//

import SwiftUI

internal struct GameControllerIndicator: View {

    internal let gameController: GameController

    internal var body: some View {
        Button {
            
        } label: {
            HStack {
                VStack {
                    image

                    ProgressView(value: gameController.batteryLevel ?? 1)
                        .accentColor(batteryIndicatorColor)
                        .border(imageColor, width: 0.5)
                        .frame(width: 35)
                }

                Text(gameController.playerIndex.map { String($0) } ?? "X" )
                    .accentColor(imageColor)
            }
        }
    }

    private var batteryIndicatorColor: Color {

        guard let level = gameController.batteryLevel else {
            return .gray
        }

        switch level {
        case let level where level < 0.15:
            return .red

        case let level where level < 0.5:
            return .yellow

        case let level where level > 0.5:
            return .green

        default:
            return .gray
        }
    }

    private var imageColor: Color {
        guard let index = gameController.playerIndex else { return .gray }

        switch index {
        case 1:
            return .purple

        case 2:
            return .green

        case 3:
            return .blue

        case 4:
            return .purple

        default:
            return .gray
        }
    }

    private var image: some View {
        switch gameController.kind {
        case .controller:
            return Image(systemName: "gamecontroller")
                .foregroundColor(imageColor)

        case .keyboard:
            return Image(systemName: "keyboard")
                .foregroundColor(imageColor)
        }
    }
}

struct GameControllerIndicator_Previews: PreviewProvider {

    class MockedGameController: GameController {
        let playerIndex: Int?
        let batteryLevel: Float?
        let kind: GameControllerType

        var rustBoy: RustBoy? = nil

        init(playerIndex: Int?, batteryLevel: Float?, kind: GameControllerType) {
            self.playerIndex = playerIndex
            self.batteryLevel = batteryLevel
            self.kind = kind
        }
    }

    static var previews: some View {
        VStack {
            GameControllerIndicator(gameController: MockedGameController(playerIndex: 1, batteryLevel: 0.1, kind: .controller))
                .padding()

            GameControllerIndicator(gameController: MockedGameController(playerIndex: 2, batteryLevel: 0.35, kind: .controller))
                .padding()

            GameControllerIndicator(gameController: MockedGameController(playerIndex: 3, batteryLevel: 0.75, kind: .controller))
                .padding()

            GameControllerIndicator(gameController: MockedGameController(playerIndex: nil, batteryLevel: nil, kind: .keyboard))
                .padding()
        }
        .previewLayout(.sizeThatFits)
    }
}
