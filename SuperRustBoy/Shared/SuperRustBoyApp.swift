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

    @StateObject
    private var controllerManager = GameControllerManager()

    @StateObject
    private var snes = SNES.setup {
        $0.autoBoot = true
    }

    @StateObject
    private var rustboy = RustBoy.setup {
        $0.autoBoot = true
    }

    @State
    private var rom: OpenRomPage.ROMType?

    var body: some View {
        switch rom {
        case .rustboy(let cartridge):
            rustboy.cartridge = cartridge
            controllerManager.receiver = rustboy
            return AnyView(RustBoyView(rustBoy: rustboy))

        case .snes(let cartridge):
            snes.cartridge = cartridge
            controllerManager.receiver = snes
            return AnyView(SNESView(snes: snes, gameControllerManager: controllerManager))

        default:
            return AnyView(OpenRomPage(rom: $rom))
        }
    }
}
