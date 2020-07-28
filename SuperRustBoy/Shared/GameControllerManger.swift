//
//  GameControllerManger.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/06/2020.
//

import Combine
import Foundation
import GameController

internal protocol GameController: AnyObject {
    var playerIndex: Int? { get }
    var batteryLevel: Float? { get }
    var kind: GameControllerType { get }
    var rustBoy: RustBoy? { get set }
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

    weak var rustBoy: RustBoy?

    let internalController: IternalGameControllerType

    internal enum IternalGameControllerType {
        case keyboard(GCKeyboard)
        case controller(GCController)
    }

    init(controller: GCController) {
        self.internalController = .controller(controller)

        controller.extendedGamepad?.dpad.valueChangedHandler = { [rustBoy] (dpad, x, y) in
             switch x {
             case 1:
                 rustBoy?.buttonPressed(.right)

             case -1:
                 rustBoy?.buttonPressed(.left)

             default:
                 rustBoy?.buttonUnpressed(.right)
                 rustBoy?.buttonUnpressed(.left)
             }

             switch y {
             case 1:
                 rustBoy?.buttonPressed(.up)

             case -1:
                 rustBoy?.buttonPressed(.down)

             default:
                 rustBoy?.buttonUnpressed(.up)
                 rustBoy?.buttonUnpressed(.down)
             }
         }

        controller.extendedGamepad?.buttonA.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.a) : rustBoy?.buttonUnpressed(.a)
        }

        controller.extendedGamepad?.buttonB.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.b) : rustBoy?.buttonUnpressed(.b)
        }

        controller.extendedGamepad?.buttonMenu.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.start) : rustBoy?.buttonUnpressed(.start)
        }

        controller.extendedGamepad?.buttonOptions?.valueChangedHandler = { [self] (button, pressure, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.select) : rustBoy?.buttonUnpressed(.select)
        }
    }

    init(keyboard: GCKeyboard) {
        self.internalController = .keyboard(keyboard)

        keyboard.keyboardInput?.button(forKeyCode: .upArrow)?.valueChangedHandler = { [self] (_, _, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.up) : rustBoy?.buttonUnpressed(.up)
        }

        keyboard.keyboardInput?.button(forKeyCode: .downArrow)?.valueChangedHandler = { [self] (_, _, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.down) : rustBoy?.buttonUnpressed(.down)
        }

        keyboard.keyboardInput?.button(forKeyCode: .leftArrow)?.valueChangedHandler = { [self] (_, _, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.left) : rustBoy?.buttonUnpressed(.left)
        }

        keyboard.keyboardInput?.button(forKeyCode: .rightArrow)?.valueChangedHandler = { [self] (_, _, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.right) : rustBoy?.buttonUnpressed(.right)
        }

        keyboard.keyboardInput?.button(forKeyCode: .keyA)?.valueChangedHandler = { [self] (_, _, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.a) : rustBoy?.buttonUnpressed(.a)
        }

        keyboard.keyboardInput?.button(forKeyCode: .keyS)?.valueChangedHandler = { [self] (_, _, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.b) : rustBoy?.buttonUnpressed(.b)
        }

        keyboard.keyboardInput?.button(forKeyCode: .returnOrEnter)?.valueChangedHandler = { [self] (_, _, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.start) : rustBoy?.buttonUnpressed(.start)
        }

        keyboard.keyboardInput?.button(forKeyCode: .spacebar)?.valueChangedHandler = { [self] (_, _, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.select) : rustBoy?.buttonUnpressed(.select)
        }
    }
}
