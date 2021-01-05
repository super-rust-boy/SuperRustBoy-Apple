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

    var body: some Scene {
        WindowGroup {
            SuperRustBoyWindow()
        }
    }
}

struct SuperRustBoyWindow: View {

    @StateObject
    private var controllerManager = GameControllerManager()

    @AppStorage("showOnScreenControls")
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
    private var emulator: Models.Emulator?

    @State
    private var filePickerOpen = false

    private let buttonSize = CGFloat(44)

    var body: some View {
        VStack {
            HStack(spacing: 15) {
                Group {
                    Button(action: { filePickerOpen = true }, label: {
                        Image(systemName: "folder")
                    })

                    Button(action: { withAnimation { showUI.toggle() }}, label: {
                        showUI
                            ? Image(systemName: "gamecontroller.fill")
                            : Image(systemName: "gamecontroller")
                    })

                    Button(action: { mute.toggle() }, label: {
                        mute
                            ? Image(systemName: "speaker.slash.fill")
                            : Image(systemName: "speaker.wave.2.fill")
                    })
                }
                .frame(width: buttonSize, height: buttonSize)

                ForEach(controllerManager.controllers, id: \.id) { controller in
                    Menu {
                        Button("Player 1") { controller.playerIndex = .player1 }
                        Button("Player 2") { controller.playerIndex = .player2 }
                    } label: {
                        GameControllerIndicator(gameController: controller)
                    }
                }
            }

            Spacer()

            switch emulator {
            case .rustboy(let rustboy):
                RustBoyView(rustBoy: rustboy, showUI: showUI)

            case .snes(let snes):
                SNESView(snes: snes, showUI: showUI)

            case .none:
                EmptyView()
            }

            Spacer()
        }
        .fileImporter(isPresented: $filePickerOpen, allowedContentTypes: [UTType.item]) { urlResult in

            guard let romURL = try? urlResult.get() else { return }

            romURL.startAccessingSecurityScopedResource()
            let cartridge: Models.Cartridge?

            switch romURL.pathExtension {
            case "sfc", "smc":
                cartridge = Models.Cartridge.snes(SNES.Cartridge(path: romURL.path, saveFilePath: Self.savePath(forRomURL: romURL)))

            case "gb", "gbc":
                cartridge = Models.Cartridge.rustboy(RustBoy.Cartridge(path: romURL.path, saveFilePath: Self.savePath(forRomURL: romURL)))

            default:
                cartridge = nil
            }

            print("Setting emulator")
            emulator = cartridge.flatMap(Models.Emulator.init)
            controllerManager.receiver = emulator?.receiver
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
