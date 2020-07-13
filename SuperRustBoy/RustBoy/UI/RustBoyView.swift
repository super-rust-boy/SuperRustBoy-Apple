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
                Spacer()

                HStack {
                    Self.optionButton(rustBoy: rustBoy, title: "Select")
                    Self.optionButton(rustBoy: rustBoy, title: "Start")
                }
                .padding()

                Spacer()
            }
            .frame(maxHeight: Self.elementSize)
        }
    }

    private static let elementSize = CGFloat(75)
    private static let elementSizeTimesTwo = elementSize * 2

    private static func optionButton(rustBoy: RustBoy, title: String) -> some View {
        VStack {
            RustBoyButton(type: .start, rustBoy: rustBoy) { RoundedRectangle(cornerRadius: 25) }
            Text(title)
        }
        .frame(minWidth: 50, maxWidth: 60, maxHeight: 50)
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
