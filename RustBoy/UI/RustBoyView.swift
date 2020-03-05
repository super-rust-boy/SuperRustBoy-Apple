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

	internal let rustBoy: RustBoy

    internal init(rustBoy: RustBoy) {
        self.rustBoy = rustBoy

        self.cancellable = pickerData.$fileURLs
            .compactMap { $0.first }
            .map { $0 as NSURL }
            .compactMap {
                guard let romPath = $0.resourceSpecifier else { return nil }
                guard let savePath = Self.savePath(forRomURL: $0) else { return nil }

                return RustBoy.Cartridge(path: romPath, saveFilePath: savePath)
            }
            .sink {
                rustBoy.cartridge = $0
            }
    }

    @ObservedObject
    private var pickerData: FilePickerView.Data = FilePickerView.Data()

    @State
    private var pickerOpen = false

    private var cancellable: AnyCancellable?

	internal var body: some View {
		VStack {
			Display(rustBoy: rustBoy)

			HStack {
				DPad(rustBoy: rustBoy)
					.padding()

				HStack {
                    RustBoyButton(type: .b, rustBoy: rustBoy) { RoundButton(text: "B") }
                    RustBoyButton(type: .a, rustBoy: rustBoy) { RoundButton(text: "A") }
				}
                    .padding()
			}

            HStack {

                Button(action: {
                    self.pickerOpen = true
                }, label: {
                    ZStack {
                        Circle()
                            .frame(width: 60, height: 60)

                        Text("Open")
                            .foregroundColor(.white)
                    }
                })

                HStack {
                    Self.optionButton(rustBoy: rustBoy, title: "Select")
                    Self.optionButton(rustBoy: rustBoy, title: "Start")
                }
			}
				.padding()
        }
            .sheet(isPresented: $pickerOpen) {
                FilePickerView(data: self.pickerData)
            }
	}

    private static func optionButton(rustBoy: RustBoy, title: String) -> some View {
        VStack {
            RustBoyButton(type: .start, rustBoy: rustBoy) { RoundedRectangle(cornerRadius: 25) }
            Text(title)
        }
            .frame(width: 75, height: 50)
    }

    private static func savePath(forRomURL romURL: NSURL) -> String? {

        guard let documentsPathURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first as NSURL? else { return nil }
        guard let documentsPath = documentsPathURL.resourceSpecifier else { return nil }
        guard let romFilename = romURL.deletingPathExtension?.lastPathComponent else { return nil }

        return documentsPath + romFilename + ".sav"
    }
}
