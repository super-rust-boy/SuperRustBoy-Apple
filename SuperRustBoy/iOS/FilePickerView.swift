//
//  FilePickerView.swift
//  SuperRustBoy-iOS
//
//  Created by Sean Inge Asbjørnsen on 27/02/2020.
//  Copyright © 2020 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct FilePickerView: UIViewControllerRepresentable {

    internal let data: Data

    internal func makeUIViewController(context: UIViewControllerRepresentableContext<FilePickerView>) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(documentTypes: ["public.item"], in: .import)
        picker.delegate = context.coordinator
        return picker
    }

    internal func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<FilePickerView>) {

    }

    internal func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    internal class Coordinator: NSObject, UIDocumentPickerDelegate {

        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            parent.data.fileURLs = urls
        }

        fileprivate var parent: FilePickerView

        fileprivate init(parent: FilePickerView) {
            self.parent = parent
        }
    }

    internal class Data: ObservableObject {
        @Published var fileURLs: [URL] = []
    }
}
