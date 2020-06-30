//
//  FilePickerView.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 05/03/2020.
//  Copyright © 2020 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct FilePickerView: View {

    internal var body: some View {
        return EmptyView()
    }

    internal let data: Data

    internal class Data: ObservableObject {
        @Published var fileURLs: [URL] = []
    }
}
