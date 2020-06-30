//
//  GameControllerManger.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/06/2020.
//

import Combine
import Foundation
import GameController

internal final class GameControllerManager {

    internal static let shared = GameControllerManager()

    private var cancellables = Set<AnyCancellable>()

    private init() {
        NotificationCenter
            .default
            .publisher(for: .GCControllerDidConnect)
            .compactMap { $0.object as? GCController }
            .sink { controller in
                print("Controller: \(controller)")
//                controllers.forEach { Self.setupController(controller: $0, rustBoy: self.rustBoy) }
            }
            .store(in: &cancellables)

        NotificationCenter
            .default
            .publisher(for: .GCKeyboardDidConnect)
            .compactMap { $0.object as? GCKeyboard }
            .sink { keyboard in
                print("Keyboard: \(keyboard)")
            }
            .store(in: &cancellables)
    }

    private static func setupController(controller: GCController, rustBoy: RustBoy) {

        controller.extendedGamepad?.dpad.valueChangedHandler = { (dpad, x, y) in
             switch x {
             case 1:
                 rustBoy.buttonPressed(.right)

             case -1:
                 rustBoy.buttonPressed(.left)

             default:
                 rustBoy.buttonUnpressed(.right)
                 rustBoy.buttonUnpressed(.left)
             }

             switch y {
             case 1:
                 rustBoy.buttonPressed(.up)

             case -1:
                 rustBoy.buttonPressed(.down)

             default:
                 rustBoy.buttonUnpressed(.up)
                 rustBoy.buttonUnpressed(.down)
             }
         }

        controller.extendedGamepad?.buttonA.valueChangedHandler = { (button, pressure, isPressed) in
            isPressed ? rustBoy.buttonPressed(.a) : rustBoy.buttonUnpressed(.a)
        }

        controller.extendedGamepad?.buttonB.valueChangedHandler = { (button, pressure, isPressed) in
            isPressed ? rustBoy.buttonPressed(.b) : rustBoy.buttonUnpressed(.b)
        }

        controller.extendedGamepad?.buttonMenu.valueChangedHandler = { (button, pressure, isPressed) in
            isPressed ? rustBoy.buttonPressed(.start) : rustBoy.buttonUnpressed(.start)
        }

        controller.extendedGamepad?.buttonOptions?.valueChangedHandler = { (button, pressure, isPressed) in
            isPressed ? rustBoy.buttonPressed(.select) : rustBoy.buttonUnpressed(.select)
        }
    }
}
