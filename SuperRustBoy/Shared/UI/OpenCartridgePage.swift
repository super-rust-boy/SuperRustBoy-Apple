//
//  OpenRomPage.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/10/2020.
//

import SwiftUI
import UniformTypeIdentifiers

struct OpenCartridgePage: View {

    enum Cartridge {
        case rustboy(RustBoy.Cartridge)
        case snes(SNES.Cartridge)
    }

    @Binding
    var cartridge: Cartridge?

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
                        cartridge = .snes(SNES.Cartridge(path: romURL.path, saveFilePath: Self.savePath(forRomURL: romURL)))

                    case "gb", "gbc":
                        cartridge = .rustboy(RustBoy.Cartridge(path: romURL.path, saveFilePath: Self.savePath(forRomURL: romURL)))
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
    static var cartridge: OpenCartridgePage.Cartridge?

    static var previews: some View {
        OpenCartridgePage(cartridge: $cartridge)
    }
}
