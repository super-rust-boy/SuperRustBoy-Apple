//
//  SNESView.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/07/2020.
//

import SwiftUI

internal struct SNESView: View {

    internal let snes: SNES?

    internal let showUI: Bool

    internal var body: some View {
        VStack {

            Display(emulator: snes)
                .aspectRatio(CGSize(width: 4, height: 3), contentMode: .fit)

            Spacer()

            if showUI {
                VStack {
                    HStack {
                        DPad(emulator: snes, index: .player1, direction: SNES.Button.init)
                            .frame(maxWidth: 200)
                        Spacer()
                        ActionButtons(snes: snes)
                    }
                    .frame(height: 200)
                    .padding()

                    HStack {
                        EmulatorButton(emulator: snes, button: .start, index: .player1) {
                            OptionButton(text: "Start")
                        }

                        EmulatorButton(emulator: snes, button: .select, index: .player1) {
                            OptionButton(text: "Select")
                        }
                    }
                }
            }
        }
    }

    private struct ActionButtons: View {

        let snes: SNES?

        private let size = CGFloat(60)

        var body: some View {
            HStack {
                EmulatorButton(emulator: snes, button: .y, index: .player1) {
                    RoundButton(text: "Y", color: .green)
                }
                .frame(width: size, height: size)

                VStack {
                    EmulatorButton(emulator: snes, button: .x, index: .player1) {
                        RoundButton(text: "X", color: .blue)
                    }
                    .frame(width: size, height: size)

                    EmulatorButton(emulator: snes, button: .b, index: .player1) {
                        RoundButton(text: "B", color: .yellow)
                    }
                    .frame(width: size, height: size)
                }

                EmulatorButton(emulator: snes, button: .a, index: .player1) {
                    RoundButton(text: "A", color: .red)
                }
                .frame(width: size, height: size)
            }
        }
    }

    private struct OptionButton: View {
        let text: String

        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 25)
                    .frame(width: 30, height: 60)
                    .rotationEffect(.degrees(45))

                Text(text)
            }
        }
    }
}

extension SNES.Button {
    init(_ direction: DPad<CoreSNES, SNES>.Direction) {
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


struct SNESView_Previews: PreviewProvider {
    private static let deviceNames: [String] = [
        "iPhone SE (2nd generation)",
        "iPhone 11 Pro Max",
        "iPad Pro (11-inch) (2nd generation)"
    ]

    static var previews: some View {
        ForEach(deviceNames, id: \.self) { deviceName in
            SNESView(snes: nil, showUI: true)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .preferredColorScheme(.light)
    }
}
