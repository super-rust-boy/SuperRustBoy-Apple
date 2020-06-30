//
//  RustBoyView.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 23/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI
import Combine

internal struct RustBoyView: View {

    private let rustBoy: RustBoy

    internal init(rustBoy: RustBoy) {
        self.rustBoy = rustBoy
        cancellable = pickerData.$fileURLs
            .compactMap { $0.first }
            .map { $0 as NSURL }
            .compactMap {
                guard let romPath = $0.resourceSpecifier else { return nil }
                guard let savePath = Self.savePath(forRomURL: $0) else { return nil }

                return RustBoy.Cartridge(path: romPath, saveFilePath: savePath)
            }
            .assign(to: \.cartridge, on: rustBoy)
    }

    internal var body: some View {
        VStack {
            Display(rustBoy: rustBoy)

            HStack {
                DPad(rustBoy: rustBoy)
                    .frame(maxWidth: Self.elementSizeTimesTwo, maxHeight: Self.elementSizeTimesTwo)
                    .padding()
                    .layoutPriority(1)

                Spacer()

                HStack {
                    RustBoyButton(type: .b, rustBoy: rustBoy) { RoundButton(text: "B") }
                        .frame(maxHeight: Self.elementSize)
                    RustBoyButton(type: .a, rustBoy: rustBoy) { RoundButton(text: "A") }
                        .frame(maxHeight: Self.elementSize)
                }
                    .frame(maxWidth: Self.elementSizeTimesTwo)
                    .padding()
                    .layoutPriority(1)
            }
                .frame(maxHeight: Self.elementSize * 4)

            HStack {

                HStack {
                    Button(action: {
                        self.pickerOpen = true
                    }, label: {
                        ZStack {
                            Circle()
                                .frame(width: 45)

                            Text("Open")
                                .foregroundColor(.white)
                        }
                    })

                    // Used as a spacer
                    Color.black
                        .opacity(0)
                }
                    .padding()

                HStack {
                    Self.optionButton(rustBoy: rustBoy, title: "Select")
                    Self.optionButton(rustBoy: rustBoy, title: "Start")
                }
                    .padding()

                // Used as a spacer
                Color.black
                    .opacity(0)
            }
                .frame(maxHeight: Self.elementSize)
        }
            .sheet(isPresented: $pickerOpen) {
                FilePickerView(data: self.pickerData)
            }
    }

    @StateObject
    private var pickerData: FilePickerView.Data = FilePickerView.Data()

    @State
    private var pickerOpen = false

    private var cancellable: AnyCancellable?

    private static let elementSize = CGFloat(75)
    private static let elementSizeTimesTwo = elementSize * 2

    private static func optionButton(rustBoy: RustBoy, title: String) -> some View {
        VStack {
            RustBoyButton(type: .start, rustBoy: rustBoy) { RoundedRectangle(cornerRadius: 25) }
            Text(title)
        }
            .frame(minWidth: 50, maxWidth: 60, maxHeight: 50)
    }

    private static func savePath(forRomURL romURL: NSURL) -> String? {

        guard let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as NSURL? else { return nil }
        guard let documentsPath = documentsPathURL.resourceSpecifier else { return nil }
        guard let romFilename = romURL.deletingPathExtension?.lastPathComponent else { return nil }

        return documentsPath + romFilename + ".sav"
    }
}

struct RustBoyView_Preview: PreviewProvider {

    private static let deviceNames: [String] = [
        "iPhone SE (2nd generation)",
        "iPhone 11 Pro Max",
        "iPad Pro (11-inch) (2nd generation)"
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            RustBoyView(rustBoy: RustBoy())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
    }
}
