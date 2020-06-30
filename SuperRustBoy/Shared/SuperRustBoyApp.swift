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

    var body: some Scene {
        RustBoyScene(controllerManager: controllerManager)
    }
}

extension RustBoy: ObservableObject {}

struct RustBoyScene: Scene {

    @ObservedObject
    internal var controllerManager: GameControllerManager

    @StateObject
    private var rustBoy = RustBoy()

    var body: some Scene {
        WindowGroup {
            RustBoyView(rustBoy: rustBoy)
        }
    }
}
