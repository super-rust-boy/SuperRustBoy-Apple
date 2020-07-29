//
//  Emulator.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 29/07/2020.
//

import Foundation

internal class Emulator {
    internal var autoBoot = false

    internal enum BootStatus: Error {
        case cartridgeMissing
        case failedToInitCore
        case success
    }

    internal struct Cartridge: Equatable {
        internal let path: String
        internal let saveFilePath: String
    }

    internal var display: DisplayView?
}
