//
//  SuperRustBoyApp.swift
//  Shared
//
//  Created by Sean Inge Asbjørnsen on 30/06/2020.
//

import SwiftUI

@main
struct SuperRustBoyApp: App {

    @StateObject
    private var controllerManager = GameControllerManager()

    @State
    private var filePickerOpen = false

    @State
    private var romURL: URL?

    var body: some Scene {
        WindowGroup { () -> AnyView in
            if let romURL = romURL, romURL.startAccessingSecurityScopedResource() {
                switch romURL.pathExtension {
                case "sfc", "smc":
                    let snes = SNES()
                    snes.autoBoot = true
                    snes.cartridge = SNES.Cartridge(path: romURL.path, saveFilePath: Self.savePath(forRomURL: romURL))

                    // TODO: This won't work if controllers are attached at a later point in time
                    controllerManager.controllers.forEach { controller in
                        controller.receiver = snes
                    }

                    return AnyView(SNESView(snes: snes))

                case "gb", "gbc":
                    let rustboy = RustBoy()
                    rustboy.autoBoot = true
                    rustboy.cartridge = RustBoy.Cartridge(path: romURL.path, saveFilePath: Self.savePath(forRomURL: romURL))

                    // TODO: This won't work if controllers are attached at a later point in time
                    controllerManager.controllers.forEach { controller in
                        controller.receiver = rustboy
                    }

                    return AnyView(RustBoyView(rustBoy: rustboy))

                default:
                    break
                }
            }

            return AnyView(OpenRomPage(romURL: $romURL))
        }
    }

    private static func savePath(forRomURL romURL: URL) -> String {
        print("ROM path: \(romURL.path)")
        let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let savePath = documentDirectory.path + "/\(romURL.deletingPathExtension().lastPathComponent).sav"
        print("Save path: \(savePath)")
        return savePath
    }
}
