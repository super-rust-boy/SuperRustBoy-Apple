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

    internal let rustBoy: RustBoy?

    internal let showUI: Bool

    private static let columns = [
        GridItem(.flexible(minimum: 50)),
        GridItem(.fixed(100)),
        GridItem(.flexible(minimum: 50))
    ]

    internal var body: some View {
        VStack {

            Spacer()

            Display(emulator: rustBoy)
                .aspectRatio(CGSize(width: 10, height: 9), contentMode: .fit)

            Spacer()

            if showUI {
                HStack {
                    DPad(emulator: rustBoy, index: .player1, direction: RustBoy.Button.init)
                        .frame(maxWidth: Self.elementSizeTimesTwo, maxHeight: Self.elementSizeTimesTwo)
                        .padding()

                    Spacer()

                    HStack {
                        EmulatorButton(emulator: rustBoy, button: .b, index: .player1) {
                            RoundButton(text: "B")
                        }
                        .frame(maxHeight: Self.elementSize)

                        EmulatorButton(emulator: rustBoy, button: .a, index: .player1) {
                            RoundButton(text: "A")
                        }
                        .frame(maxHeight: Self.elementSize)
                    }
                    .frame(maxWidth: Self.elementSizeTimesTwo)
                    .padding()
                }
                .padding(.bottom, 25)

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
    }

    private static let elementSize = CGFloat(75)
    private static let elementSizeTimesTwo = elementSize * 2

    private struct OptionButton: View {

        let rustBoy: RustBoy?
        let buttonType: RustBoy.Button
        let title: String

        var body: some View {
            EmulatorButton(emulator: rustBoy, button: buttonType, index: .player1) {
                VStack {
                    RoundedRectangle(cornerRadius: 25)
                    Text(title)
                }
            }
            .frame(minWidth: 50, maxWidth: 60, maxHeight: 50)
        }
    }
}

private extension RustBoy.Button {
    init(_ direction: DPad<CoreRustBoy, RustBoy>.Direction) {
        switch direction {
        case .left:
            self = .left
        case .up:
            self = .up
        case .right:
            self = .right
        case .down:
            self = .down
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
            RustBoyView(rustBoy: nil, showUI: true)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .preferredColorScheme(.light)
    }
}
