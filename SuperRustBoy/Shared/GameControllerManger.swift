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
    func buttonPressed(_ button: GameControllerButton)
    func buttonUnpressed(_ button: GameControllerButton)
}

internal protocol KeyboardReceiver: AnyObject {
    func buttonPressed(_ button: GCKeyCode)
    func buttonUnpressed(_ button: GCKeyCode)
}

internal protocol GameController: AnyObject {
    var playerIndex: Int? { get }
    var batteryLevel: Float? { get }
    var kind: GameControllerType { get }
    var receiver: (GameControllerReceiver & KeyboardReceiver)? { get set }
}

internal enum GameControllerType {
    case keyboard, controller
}

internal final class GameControllerManager: ObservableObject {

    internal private(set) var controllers = [GameController]()

    internal init() {
        NotificationCenter
            .default
            .publisher(for: .GCControllerDidConnect)
            .compactMap { $0.object as? GCController }
            .sink { controller in
                self.controllers.append(Controller(controller: controller))
                self.objectWillChange.send()
            }
            .store(in: &cancellables)

        NotificationCenter
            .default
            .publisher(for: .GCKeyboardDidConnect)
            .compactMap { $0.object as? GCKeyboard }
            .sink { keyboard in
                self.controllers.append(Controller(keyboard: keyboard))
                self.objectWillChange.send()
            }
            .store(in: &cancellables)
    }

    private var cancellables = Set<AnyCancellable>()
}

fileprivate class Controller: GameController {
    var playerIndex: Int? {
        nil
    }

    var batteryLevel: Float? {
        switch internalController {
        case .controller(let controller):
            return controller.battery?.batteryLevel
        case .keyboard:
            return nil
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

    let internalController: IternalGameControllerType

    internal enum IternalGameControllerType {
        case keyboard(GCKeyboard)
        case controller(GCController)
    }

    init(controller: GCController) {
        self.internalController = .controller(controller)

        controller.extendedGamepad?.dpad.valueChangedHandler = { [self] (dpad, x, y) in
            switch x {
            case 1:
                receiver?.buttonPressed(.right)

            case -1:
                receiver?.buttonPressed(.left)

            default:
                receiver?.buttonUnpressed(.right)
                receiver?.buttonUnpressed(.left)
            }

            switch y {
            case 1:
                receiver?.buttonPressed(.up)

            case -1:
                receiver?.buttonPressed(.down)

            default:
                receiver?.buttonUnpressed(.up)
                receiver?.buttonUnpressed(.down)
            }
        }

        controller.extendedGamepad?.buttonA.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? receiver?.buttonPressed(.a) : receiver?.buttonUnpressed(.a)
        }

        controller.extendedGamepad?.buttonB.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? receiver?.buttonPressed(.b) : receiver?.buttonUnpressed(.b)
        }

        controller.extendedGamepad?.buttonX.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? receiver?.buttonPressed(.x) : receiver?.buttonUnpressed(.x)
        }

        controller.extendedGamepad?.buttonY.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? receiver?.buttonPressed(.y) : receiver?.buttonUnpressed(.y)
        }

        controller.extendedGamepad?.buttonMenu.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? receiver?.buttonPressed(.menu) : receiver?.buttonUnpressed(.menu)
        }

        controller.extendedGamepad?.buttonOptions?.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? receiver?.buttonPressed(.options) : receiver?.buttonUnpressed(.options)
        }

        controller.extendedGamepad?.leftShoulder.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? receiver?.buttonPressed(.leftShoulder) : receiver?.buttonUnpressed(.leftShoulder)
        }

        controller.extendedGamepad?.rightShoulder.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? receiver?.buttonPressed(.rightShoulder) : receiver?.buttonUnpressed(.rightShoulder)
        }
    }

    init(keyboard: GCKeyboard) {
        self.internalController = .keyboard(keyboard)

        keyboard.keyboardInput?.keyChangedHandler = { [self] (input, buttonInput, keyCode, isPressed) in
            isPressed ? receiver?.buttonPressed(keyCode) : receiver?.buttonUnpressed(keyCode)
        }
    }
}
