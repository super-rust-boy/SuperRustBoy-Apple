//
//  OpenRomPage.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/10/2020.
//

import SwiftUI
import UniformTypeIdentifiers

struct OpenRomPage: View {

    enum ROMType {
        case rustboy(RustBoy.Cartridge)
        case snes(SNES.Cartridge)
    }

    @Binding
    var rom: ROMType?

    @State
    private var filePickerOpen = false

    var body: some View {
        VStack {
            Text("Select ROM")
            Button("Open", action: { filePickerOpen = true })
                .fileImporter(isPresented: $filePickerOpen, allowedContentTypes: [UTType.item]) { urlResult in

                    guard let romURL = try? urlResult.get() else { return }

                    romURL.startAccessingSecurityScopedResource()

                    switch romURL.pathExtension {
                    case "sfc", "smc":
                        rom = .snes(SNES.Cartridge(path: romURL.path, saveFilePath: Self.savePath(forRomURL: romURL)))

                    case "gb", "gbc":
                        rom = .rustboy(RustBoy.Cartridge(path: romURL.path, saveFilePath: Self.savePath(forRomURL: romURL)))
                    default:
                        break
                    }
                }
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

struct OpenRomPage_Previews: PreviewProvider {

    @State
    static var rom: OpenRomPage.ROMType?

    static var previews: some View {
        OpenRomPage(rom: $rom)
    }
}
