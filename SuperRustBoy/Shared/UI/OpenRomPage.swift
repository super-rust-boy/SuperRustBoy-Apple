//
//  OpenRomPage.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/10/2020.
//

import SwiftUI
import UniformTypeIdentifiers

struct OpenRomPage: View {

    @Binding
    var romURL: URL?

    @State
    private var filePickerOpen = false

    var body: some View {
        VStack {
            Text("Select ROM")
            Button("Open", action: { filePickerOpen = true })
                .fileImporter(isPresented: $filePickerOpen, allowedContentTypes: [UTType.item]) { urlResult in
                    romURL = try? urlResult.get()
                }
        }
    }
}

struct OpenRomPage_Previews: PreviewProvider {

    @State
    static var romURL: URL?

    static var previews: some View {
        OpenRomPage(romURL: $romURL)
    }
}
