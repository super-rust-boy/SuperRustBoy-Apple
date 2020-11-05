//
//  SNESView.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/07/2020.
//

import SwiftUI

internal struct SNESView: View {

    internal let snes: SNES

    internal let showUI: Bool

    internal var body: some View {
        VStack {

            Display(emulator: snes)
                .aspectRatio(CGSize(width: 4, height: 3), contentMode: .fit)

            Spacer()

            if showUI {
                VStack {
                    HStack {
                        DPad { direction in
                            snes.buttonPressed(SNES.Button(direction), playerIndex: .player1)
                        } onTouchUp: { direction in
                            snes.buttonUnpressed(SNES.Button(direction), playerIndex: .player1)
                        }

                        ActionButtons(snes: snes)
                    }
                    .frame(height: 200)
                    .padding()

                    HStack {
                        EmulatorButton(
                            content: OptionButton(text: "Start"),
                            button: .start,
                            onTouchDown: { button in snes.buttonPressed(button, playerIndex: .player1) },
                            onTouchUp: { button in snes.buttonUnpressed(button, playerIndex: .player1) }
                        )

                        EmulatorButton(
                            content: OptionButton(text: "Select"),
                            button: .select,
                            onTouchDown: { button in snes.buttonPressed(button, playerIndex: .player1) },
                            onTouchUp: { button in snes.buttonUnpressed(button, playerIndex: .player1) }
                        )
                    }
                }
            }
        }
    }

    private struct ActionButtons: View {

        let snes: SNES

        private let size = CGFloat(60)

        var body: some View {
            HStack {
                EmulatorButton(
                    content: RoundButton(text: "Y", color: .green), button: .y,
                    onTouchDown: { button in snes.buttonPressed(button, playerIndex: .player1) },
                    onTouchUp: { button in snes.buttonUnpressed(button, playerIndex: .player1) }
                )
                .frame(width: size, height: size)

                VStack {
                    EmulatorButton(
                        content: RoundButton(text: "X", color: .blue), button: .x,
                        onTouchDown: { button in snes.buttonPressed(button, playerIndex: .player1) },
                        onTouchUp: { button in snes.buttonUnpressed(button, playerIndex: .player1) }
                    )
                    .frame(width: size, height: size)

                    EmulatorButton(
                        content: RoundButton(text: "B", color: .yellow), button: .b,
                        onTouchDown: { button in snes.buttonPressed(button, playerIndex: .player1) },
                        onTouchUp: { button in snes.buttonUnpressed(button, playerIndex: .player1) }
                    )
                    .frame(width: size, height: size)
                }

                EmulatorButton(
                    content: RoundButton(text: "A", color: .red), button: .a,
                    onTouchDown: { button in snes.buttonPressed(button, playerIndex: .player1) },
                    onTouchUp: { button in snes.buttonUnpressed(button, playerIndex: .player1) }
                )
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

private extension SNES.Button {
    init(_ direction: DPad.Direction) {
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
            SNESView(snes: SNES(), showUI: true)
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .preferredColorScheme(.light)
    }
}
