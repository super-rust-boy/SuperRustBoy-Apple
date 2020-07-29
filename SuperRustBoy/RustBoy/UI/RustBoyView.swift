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

    private static let columns = [
        GridItem(.flexible(minimum: 50)),
        GridItem(.fixed(100)),
        GridItem(.flexible(minimum: 50))
    ]

    internal var body: some View {
        VStack {
            Display(emulator: rustBoy)

            HStack {
                DPad(rustBoy: rustBoy)
                    .frame(maxWidth: Self.elementSizeTimesTwo, maxHeight: Self.elementSizeTimesTwo)
                    .padding()

                Spacer()

                HStack {
                    RustBoyButton(type: .b, rustBoy: rustBoy) { RoundButton(text: "B") }
                        .frame(maxHeight: Self.elementSize)
                    RustBoyButton(type: .a, rustBoy: rustBoy) { RoundButton(text: "A") }
                        .frame(maxHeight: Self.elementSize)
                }
                .frame(maxWidth: Self.elementSizeTimesTwo)
                .padding()
            }
            .padding(.bottom, 75)

            LazyVGrid(columns: Self.columns) {
                Spacer()

                VStack {
                    Spacer()
                    HStack {
                        OptionButton(rustBoy: rustBoy, buttonType: .select, title: "Select")
                        OptionButton(rustBoy: rustBoy, buttonType: .start, title: "Start")
                    }
                }
                .padding()

                Spacer()
            }
        }
    }

    private static let elementSize = CGFloat(75)
    private static let elementSizeTimesTwo = elementSize * 2

    private struct OptionButton: View {

        let rustBoy: RustBoy
        let buttonType: RustBoy.ButtonType
        let title: String

        var body: some View {
            VStack {
                RustBoyButton(type: buttonType, rustBoy: rustBoy) { RoundedRectangle(cornerRadius: 25) }
                Text(title)
            }
            .frame(minWidth: 50, maxWidth: 60, maxHeight: 50)
        }
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
        .preferredColorScheme(.light)
    }
}
