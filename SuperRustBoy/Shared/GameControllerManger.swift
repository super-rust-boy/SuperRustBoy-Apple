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
        didSet {
            controllers.forEach { $0.receiver = receiver }
            objectWillChange.send()
        }
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

        NotificationCenter
            .default
            .publisher(for: .GCControllerDidDisconnect)
            .compactMap { $0.object as? GCController }
            .sink { [weak self] removedController in
                guard let self = self else { return }
                self.controllers.removeAll(where: { controller in
                    switch controller.internalController {
                    case .controller(let internalController):
                        return internalController === removedController

                    case .keyboard:
                        return false
                    }
                })
            }
            .store(in: &cancellables)

        NotificationCenter
            .default
            .publisher(for: .GCKeyboardDidDisconnect)
            .compactMap { $0.object as? GCKeyboard }
            .sink { [weak self] removedKeyboard in
                guard let self = self else { return }
                self.controllers.removeAll(where: { controller in
                    switch controller.internalController {
                    case .keyboard(let internalKeyboard):
                        return internalKeyboard === removedKeyboard

                    case .controller:
                        return false
                    }
                })
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
                updateController(controller)
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

    fileprivate let internalController: InternalGameControllerType

    internal enum InternalGameControllerType {
        case keyboard(GCKeyboard)
        case controller(GCController)
    }

    init(controller: GCController, playerIndex: PlayerIndices.FourPlayer) {
        self.internalController = .controller(controller)
        self.playerIndex = playerIndex

        updateController(controller)

        controller.extendedGamepad?.dpad.valueChangedHandler = { [self] (dpad, x, y) in
            switch x {
            case 1:
                receiver?.buttonPressed(.right, playerIndex: self.playerIndex)

            case -1:
                receiver?.buttonPressed(.left, playerIndex: self.playerIndex)

            default:
                receiver?.buttonUnpressed(.right, playerIndex: self.playerIndex)
                receiver?.buttonUnpressed(.left, playerIndex: self.playerIndex)
            }

            switch y {
            case 1:
                receiver?.buttonPressed(.up, playerIndex: self.playerIndex)

            case -1:
                receiver?.buttonPressed(.down, playerIndex: self.playerIndex)

            default:
                receiver?.buttonUnpressed(.up, playerIndex: self.playerIndex)
                receiver?.buttonUnpressed(.down, playerIndex: self.playerIndex)
            }
        }

        controller.extendedGamepad?.buttonA.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.a, playerIndex: self.playerIndex)
                : receiver?.buttonUnpressed(.a, playerIndex: self.playerIndex)
        }

        controller.extendedGamepad?.buttonB.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.b, playerIndex: self.playerIndex)
                : receiver?.buttonUnpressed(.b, playerIndex: self.playerIndex)
        }

        controller.extendedGamepad?.buttonX.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.x, playerIndex: self.playerIndex)
                : receiver?.buttonUnpressed(.x, playerIndex: self.playerIndex)
        }

        controller.extendedGamepad?.buttonY.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.y, playerIndex: self.playerIndex)
                : receiver?.buttonUnpressed(.y, playerIndex: self.playerIndex)
        }

        controller.extendedGamepad?.buttonMenu.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.menu, playerIndex: self.playerIndex)
                : receiver?.buttonUnpressed(.menu, playerIndex: self.playerIndex)
        }

        controller.extendedGamepad?.buttonOptions?.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.options, playerIndex: self.playerIndex)
                : receiver?.buttonUnpressed(.options, playerIndex: self.playerIndex)
        }

        controller.extendedGamepad?.leftShoulder.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.leftShoulder, playerIndex: self.playerIndex)
                : receiver?.buttonUnpressed(.leftShoulder, playerIndex: self.playerIndex)
        }

        controller.extendedGamepad?.rightShoulder.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed
                ? receiver?.buttonPressed(.rightShoulder, playerIndex: self.playerIndex)
                : receiver?.buttonUnpressed(.rightShoulder, playerIndex: self.playerIndex)
        }
    }

    init(keyboard: GCKeyboard, playerIndex: PlayerIndices.FourPlayer) {
        self.internalController = .keyboard(keyboard)
        self.playerIndex = playerIndex

        keyboard.keyboardInput?.keyChangedHandler = { [self] (input, buttonInput, keyCode, isPressed) in
            isPressed
                ? receiver?.buttonPressed(keyCode, playerIndex: self.playerIndex)
                : receiver?.buttonUnpressed(keyCode, playerIndex: self.playerIndex)
        }
    }

    private func updateController(_ controller: GCController) {
        controller.playerIndex = GCControllerPlayerIndex(playerIndex)

        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0

        color.getRed(&red, green: &green, blue: &blue, alpha: nil)
        controller.light?.color = GCColor(red: Float(red), green: Float(green), blue: Float(blue))
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
