//
//  SuperRustBoyApp.swift
//  Shared
//
//  Created by Sean Inge Asbjørnsen on 30/06/2020.
//

import SwiftUI

@main
struct SuperRustBoyApp: App {

    let manager = GameControllerManager.shared

    var body: some Scene {
        WindowGroup {
            RustBoyView()
        }
    }
}
