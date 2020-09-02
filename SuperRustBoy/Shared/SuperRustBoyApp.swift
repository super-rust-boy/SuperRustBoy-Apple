//
//  SuperRustBoyApp.swift
//  Shared
//
//  Created by Sean Inge Asbjørnsen on 30/06/2020.
//

import SwiftUI
import UniformTypeIdentifiers

@main
struct SuperRustBoyApp: App {

    @StateObject
    private var controllerManager = GameControllerManager()

    var body: some Scene {
        DocumentGroup(viewing: GenericFile.self) { viewer -> AnyView in

            switch viewer.fileURL?.pathExtension {
            case "sfc", "smc":
                let snes = SNES()
                snes.autoBoot = true
                snes.cartridge = viewer
                    .fileURL
                    .map { fileURL in
                        let romPath = fileURL.path
                        let savePath = Self.savePath(forRomURL: fileURL)

                        return SNES.Cartridge(path: romPath, saveFilePath: savePath)
                    }

                // TODO: This won't work if controllers are attached at a later point in time
                controllerManager.controllers.forEach { controller in
                    controller.receiver = snes
                }

                return AnyView(SNESView(snes: snes))

            case "gb", "gba":
                let rustboy = RustBoy()
                rustboy.autoBoot = true
                rustboy.cartridge = viewer
                    .fileURL
                    .map { fileURL in
                        let romPath = fileURL.path
                        let savePath = Self.savePath(forRomURL: fileURL)

                        return RustBoy.Cartridge(path: romPath, saveFilePath: savePath)
                    }

                // TODO: This won't work if controllers are attached at a later point in time
                controllerManager.controllers.forEach { controller in
                    controller.receiver = rustboy
                }

                return AnyView(RustBoyView(rustBoy: rustboy))

            default:
                return AnyView(Color.white)
            }
        }
    }

    private static func savePath(forRomURL romURL: URL) -> String {
        romURL.deletingPathExtension().path + ".sav"
    }
}

struct GenericFile: FileDocument {
    static var readableContentTypes: [UTType] = [UTType.item]

    init(configuration: Self.ReadConfiguration) throws {}

    func fileWrapper(configuration: Self.WriteConfiguration) throws -> FileWrapper {
        FileWrapper()
    }
}
