//
//  Models.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 01/11/2020.
//

import Foundation

enum Models {}

extension Models {
    enum Emulator {
        case rustboy(RustBoy)
        case gba(GBA)
        case snes(SNES)
    }
}

extension Models {
    enum Cartridge {
        case rustboy(RustBoy.Cartridge)
        case gba(GBA.Cartridge)
        case snes(SNES.Cartridge)
    }
}

extension Models.Emulator {

    init(cart: Models.Cartridge) {
        switch cart {
        case .rustboy(let cart):
            let rustboy = RustBoy()
            rustboy.cartridge = cart
            rustboy.volume = 0
            _ = rustboy.boot()
            self = .rustboy(rustboy)

        case .gba(let cart):
            let gba = GBA()
            gba.cartridge = cart
            gba.volume = 0
            _ = gba.boot()
            self = .gba(gba)

        case .snes(let cart):
            let snes = SNES()
            snes.cartridge = cart
            snes.volume = 0
            _ = snes.boot()
            self = .snes(snes)
        }
    }


    var cartridge: Models.Cartridge? {
        switch self {
        case .rustboy(let rustboy):
            return rustboy.cartridge.map(Models.Cartridge.rustboy)

        case .gba(let gba):
            return gba.cartridge.map(Models.Cartridge.gba)

        case .snes(let snes):
            return snes.cartridge.map(Models.Cartridge.snes)
        }
    }
}

extension Models.Emulator {
    var receiver: (GameControllerReceiver & KeyboardReceiver) {
        get {
            switch self {
            case .rustboy(let emu):
                return emu

            case .gba(let emu):
                return emu

            case .snes(let emu):
                return emu
            }
        }
    }
}
