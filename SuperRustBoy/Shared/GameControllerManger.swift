//
//  GameControllerManger.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/06/2020.
//

import Combine
import Foundation
import GameController

internal protocol GameController {
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
    }

    private var cancellables = Set<AnyCancellable>()
}

fileprivate struct Controller: GameController {
    var playerIndex: Int? {
        internalController.playerIndex.rawValue
    }

    var batteryLevel: Float? {
        internalController.battery?.batteryLevel
    }

    var kind: GameControllerType {
        internalController.isAttachedToDevice ? .keyboard : .controller
    }

    weak var rustBoy: RustBoy?

    let internalController: GCController

    init(controller: GCController) {
        self.internalController = controller

        print("Controller.init: \(controller.extendedGamepad)")

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

        controller.extendedGamepad?.buttonA.valueChangedHandler = { [rustBoy] (button, pressure, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.a) : rustBoy?.buttonUnpressed(.a)
        }

        controller.extendedGamepad?.buttonB.valueChangedHandler = { [rustBoy] (button, pressure, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.b) : rustBoy?.buttonUnpressed(.b)
        }

        controller.extendedGamepad?.buttonMenu.valueChangedHandler = { [rustBoy] (button, pressure, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.start) : rustBoy?.buttonUnpressed(.start)
        }

        controller.extendedGamepad?.buttonOptions?.valueChangedHandler = { [rustBoy] (button, pressure, isPressed) in
            isPressed ? rustBoy?.buttonPressed(.select) : rustBoy?.buttonUnpressed(.select)
        }
    }
}
