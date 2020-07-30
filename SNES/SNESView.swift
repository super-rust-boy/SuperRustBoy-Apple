//
//  SNESView.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 30/07/2020.
//

import SwiftUI

internal struct SNESView: View {

    internal let snes: SNES

    internal var body: some View {
        VStack {
            Display(emulator: snes)
            VStack {
                HStack {
                    DPad(rustBoy: RustBoy())
                    ActionButtons()
                }
                .frame(height: 200)
                .padding()

                HStack {
                    OptionButton(text: "Start")
                    OptionButton(text: "Select")
                }
            }
        }
    }

    private struct ActionButtons: View {

        private let size = CGFloat(60)

        var body: some View {
            HStack {
                RoundButton(text: "Y", color: .green)
                    .frame(width: size, height: size)

                VStack {
                    RoundButton(text: "X", color: .blue)
                        .frame(width: size, height: size)
                    RoundButton(text: "B", color: .yellow)
                        .frame(width: size, height: size)
                }

                RoundButton(text: "A", color: .red)
                    .frame(width: size, height: size)
            }
        }
    }

    private struct OptionButton: View {
        let text: String

        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 25)
                    .foregroundColor(.black)
                    .frame(width: 30, height: 60)
                    .rotationEffect(.degrees(45))

                Text(text)
            }
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
            SNESView(snes: SNES())
                .previewDevice(PreviewDevice(rawValue: deviceName))
                .previewDisplayName(deviceName)
        }
        .preferredColorScheme(.light)
    }
}
