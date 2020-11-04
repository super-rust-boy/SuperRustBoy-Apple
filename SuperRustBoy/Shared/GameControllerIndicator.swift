//
//  GameControllerIndicator.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 14/07/2020.
//

import SwiftUI

internal struct GameControllerIndicator: View {

    @ObservedObject
    internal var gameController: Controller

    internal var body: some View {
        HStack {
            VStack {
                image

                if let batteryLevel = gameController.batteryLevel {
                    ProgressView(value: batteryLevel)
                        .accentColor(batteryIndicatorColor)
                        .border(iconColor, width: 0.5)
                        .padding(5)
                }
            }
            .frame(width: 35, height: 35)

            Text(String(gameController.playerIndex.rawValue))
                .foregroundColor(iconColor)
                .font(.system(size: 14, design: .monospaced))
        }
    }

    private var iconColor: Color { Color(gameController.color) }

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

    @ViewBuilder
    private var image: some View {
        switch gameController.kind {
        case .controller:
            Image(systemName: "gamecontroller")
                .foregroundColor(iconColor)

        case .keyboard:
            Image(systemName: "keyboard")
                .foregroundColor(iconColor)
        }
    }
}

//struct GameControllerIndicator_Previews: PreviewProvider {
//
//    class MockedGameController {
//        var id: ObjectIdentifier { ObjectIdentifier(self) }
//        var playerIndex: Int
//        let batteryLevel: Float?
//        let kind: GameControllerType
//
//        var receiver: (GameControllerReceiver & KeyboardReceiver)?
//
//        init(playerIndex: Int, batteryLevel: Float?, kind: GameControllerType) {
//            self.playerIndex = playerIndex
//            self.batteryLevel = batteryLevel
//            self.kind = kind
//        }
//    }
//
//    static var previews: some View {
//        VStack {
//            GameControllerIndicator(gameController: MockedGameController(playerIndex: 1, batteryLevel: nil, kind: .keyboard))
//                .padding()
//
//            GameControllerIndicator(gameController: MockedGameController(playerIndex: 2, batteryLevel: 0.1, kind: .controller))
//                .padding()
//
//            GameControllerIndicator(gameController: MockedGameController(playerIndex: 3, batteryLevel: 0.35, kind: .controller))
//                .padding()
//
//            GameControllerIndicator(gameController: MockedGameController(playerIndex: 4, batteryLevel: 0.75, kind: .controller))
//                .padding()
//
//            GameControllerIndicator(gameController: MockedGameController(playerIndex: 0, batteryLevel: nil, kind: .keyboard))
//                .padding()
//        }
//        .previewLayout(.sizeThatFits)
//    }
//}
