//
//  SuperRustBoyApp.swift
//  Shared
//
//  Created by Sean Inge Asbjørnsen on 30/06/2020.
//

import SwiftUI

extension RustBoy: ObservableObject {}
extension SNES: ObservableObject {}

@main
struct SuperRustBoyApp: App {

    var body: some Scene {
        WindowGroup {
            SuperRustBoyWindow()
        }
    }
}

struct SuperRustBoyWindow: View {

    private enum Emulator {
        case rustboy(RustBoy)
        case snes(SNES)
    }

    @StateObject
    private var controllerManager = GameControllerManager()

    @State
    private var showUI = true

    @State
    private var mute = true {
        didSet {
            switch emulator {
            case .rustboy(let instance):
                instance.volume = mute ? 0 : 0.7

            case .snes(let instance):
                instance.volume = mute ? 0 : 0.7

            case .none:
                break
            }
        }
    }

    @State
    private var emulator: Emulator?

    var body: some View {
        VStack {
            HStack {
                Button(showUI ? "Hide" : "Show") { withAnimation { showUI.toggle() }}
                    .frame(width: 75)
                Button(mute ? "Unmute" : "Mute") { withAnimation { mute.toggle() }}
                    .frame(width: 75)
                ForEach(controllerManager.controllers, id: \.id) { controller in
                    GameControllerIndicator(gameController: controller)
                }
            }

            Spacer()

            switch emulator {
            case .rustboy(let rustboy):
                RustBoyView(rustBoy: rustboy)

            case .snes(let snes):
                SNESView(snes: snes, showUI: showUI)

            default:
                OpenCartridgePage(cartridge: Binding(get: {
                    switch emulator {
                    case .rustboy(let rustboy):
                        return rustboy.cartridge.map(OpenCartridgePage.Cartridge.rustboy)

                    case .snes(let snes):
                        return snes.cartridge.map(OpenCartridgePage.Cartridge.snes)

                    default: return nil
                    }
                }, set: { romType in
                    switch romType {
                    case .rustboy(let cart):
                        let rustboy = RustBoy()
                        controllerManager.receiver = rustboy
                        rustboy.cartridge = cart
                        rustboy.volume = 0
                        _ = rustboy.boot()
                        emulator = .rustboy(rustboy)

                    case .snes(let cart):
                        let snes = SNES()
                        controllerManager.receiver = snes
                        snes.cartridge = cart
                        snes.volume = 0
                        _ = snes.boot()
                        emulator = .snes(snes)

                    default:
                        emulator = nil
                    }
                }))
            }

            Spacer()
        }
    }
}
