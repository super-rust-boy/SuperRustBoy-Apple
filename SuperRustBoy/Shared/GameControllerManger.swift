//
//  GameControllerManger.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/06/2020.
//

import Combine
import Foundation
import GameController

internal enum GameControllerButton {
    case left, up, right, down, a, b, x, y, menu, options, leftShoulder, rightShoulder
}

internal protocol GameControllerReceiver: AnyObject {
    func buttonPressed(_ button: GameControllerButton, playerIndex: PlayerIndices.FourPlayer)
    func buttonUnpressed(_ button: GameControllerButton, playerIndex: PlayerIndices.FourPlayer)
}

internal protocol KeyboardReceiver: AnyObject {
    func buttonPressed(_ button: GCKeyCode, playerIndex: PlayerIndices.FourPlayer)
    func buttonUnpressed(_ button: GCKeyCode, playerIndex: PlayerIndices.FourPlayer)
}

internal enum GameControllerType {
    case keyboard, controller
}

internal final class GameControllerManager: ObservableObject {

    internal weak var receiver: (GameControllerReceiver & KeyboardReceiver)? {
        didSet {
            controllers.forEach { $0.receiver = receiver }
        }
    }

    internal private(set) var controllers: [Controller] = [] {
        didSet { objectWillChange.send() }
    }

    internal init() {
        NotificationCenter
            .default
            .publisher(for: .GCControllerDidConnect)
            .compactMap { $0.object as? GCController }
            .sink { [weak self] controller in
                guard let self = self else { return }
                self.controllers.append(Controller(controller: controller, playerIndex: .player1))
            }
            .store(in: &cancellables)

        NotificationCenter
            .default
            .publisher(for: .GCKeyboardDidConnect)
            .compactMap { $0.object as? GCKeyboard }
            .sink { [weak self] keyboard in
                guard let self = self else { return }
                self.controllers.append(Controller(keyboard: keyboard, playerIndex: .player1))
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()
}

internal class Controller: ObservableObject {

    var id: ObjectIdentifier {
        ObjectIdentifier(self)
    }

    var playerIndex: PlayerIndices.FourPlayer {
        didSet {
            switch internalController {
            case .controller(let controller):
                controller.playerIndex = GCControllerPlayerIndex(playerIndex)

                var red: CGFloat = 0
                var green: CGFloat = 0
                var blue: CGFloat = 0

                color.getRed(&red, green: &green, blue: &blue, alpha: nil)
                controller.light?.color = GCColor(red: Float(red), green: Float(green), blue: Float(blue))

            case .keyboard:
                break
            }

            objectWillChange.send()
        }
    }

    var batteryLevel: Float? {
        switch internalController {
        case .controller(let controller):
            return controller.battery?.batteryLevel
        case .keyboard:
            return nil
        }
    }

    var color: UIColor {
        switch playerIndex {
        case .player1:
            return .green

        case .player2:
            return .yellow

        case .player3:
            return .purple

        case .player4:
            return .cyan
        }
    }

    var kind: GameControllerType {
        switch internalController {
        case .controller:
            return .controller
        case .keyboard:
            return .keyboard
        }
    }

    weak var receiver: (GameControllerReceiver & KeyboardReceiver)?

    private let internalController: IternalGameControllerType

    internal enum IternalGameControllerType {
        case keyboard(GCKeyboard)
        case controller(GCController)
    }

    init(controller: GCController, playerIndex: PlayerIndices.FourPlayer) {
        self.internalController = .controller(controller)
        self.playerIndex = playerIndex

        controller.extendedGamepad?.dpad.valueChangedHandler = { [self] (dpad, x, y) in
            switch x {
            case 1:
                receiver?.buttonPressed(.right, playerIndex: playerIndex)

            case -1:
                receiver?.buttonPressed(.left, playerIndex: playerIndex)

            default:
                receiver?.buttonUnpressed(.right, playerIndex: playerIndex)
                receiver?.buttonUnpressed(.left, playerIndex: playerIndex)
            }

            switch y {
            case 1:
                receiver?.buttonPressed(.up, playerIndex: playerIndex)

            case -1:
                receiver?.buttonPressed(.down, playerIndex: playerIndex)

            default:
                receiver?.buttonUnpressed(.up, playerIndex: playerIndex)
                receiver?.buttonUnpressed(.down, playerIndex: playerIndex)
            }
        }

        controller.extendedGamepad?.buttonA.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.a, playerIndex: playerIndex)
                : receiver?.buttonUnpressed(.a, playerIndex: playerIndex)
        }

        controller.extendedGamepad?.buttonB.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.b, playerIndex: playerIndex)
                : receiver?.buttonUnpressed(.b, playerIndex: playerIndex)
        }

        controller.extendedGamepad?.buttonX.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.x, playerIndex: playerIndex)
                : receiver?.buttonUnpressed(.x, playerIndex: playerIndex)
        }

        controller.extendedGamepad?.buttonY.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.y, playerIndex: playerIndex)
                : receiver?.buttonUnpressed(.y, playerIndex: playerIndex)
        }

        controller.extendedGamepad?.buttonMenu.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.menu, playerIndex: playerIndex)
                : receiver?.buttonUnpressed(.menu, playerIndex: playerIndex)
        }

        controller.extendedGamepad?.buttonOptions?.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.options, playerIndex: playerIndex)
                : receiver?.buttonUnpressed(.options, playerIndex: playerIndex)
        }

        controller.extendedGamepad?.leftShoulder.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.leftShoulder, playerIndex: playerIndex)
                : receiver?.buttonUnpressed(.leftShoulder, playerIndex: playerIndex)
        }

        controller.extendedGamepad?.rightShoulder.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.rightShoulder, playerIndex: playerIndex)
                : receiver?.buttonUnpressed(.rightShoulder, playerIndex: playerIndex)
        }
    }

    init(keyboard: GCKeyboard, playerIndex: PlayerIndices.FourPlayer) {
        self.internalController = .keyboard(keyboard)
        self.playerIndex = playerIndex

        keyboard.keyboardInput?.keyChangedHandler = { [self] (input, buttonInput, keyCode, isPressed) in
            isPressed
                ? receiver?.buttonPressed(keyCode, playerIndex: playerIndex)
                : receiver?.buttonUnpressed(keyCode, playerIndex: playerIndex)
        }
    }
}

private extension GCControllerPlayerIndex {
    init(_ index: PlayerIndices.FourPlayer) {
        switch index {
        case .player1:
            self = .index1
        case .player2:
            self = .index2
        case .player3:
            self = .index3
        case .player4:
            self = .index4
        }
    }
}
