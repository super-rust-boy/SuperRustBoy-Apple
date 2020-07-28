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
        DocumentGroup(viewing: GenericFile.self) { viewer -> RustBoyView in
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
                controller.rustBoy = rustboy
            }

            return RustBoyView(rustBoy: rustboy)
        }
    }

    private static func savePath(forRomURL romURL: URL) -> String {
        romURL.deletingPathExtension().path + ".sav"
    }
}

struct GenericFile: FileDocument {
    static var readableContentTypes = [UTType.item]

    init(fileWrapper: FileWrapper, contentType: UTType) throws {

    }

    // this will be called when the system wants to write our data to disk
    func write(to fileWrapper: inout FileWrapper, contentType: UTType) throws {

    }
}
