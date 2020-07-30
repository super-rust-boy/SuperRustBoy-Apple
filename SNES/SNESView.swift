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
                .padding()

                HStack {
                    OptionButton(text: "Start")
                    OptionButton(text: "Select")
                }
            }
        }
    }

    private struct ActionButtons: View {
        var body: some View {
            HStack {
                RoundButton(text: "Y", color: .green)

                VStack {
                    RoundButton(text: "X", color: .blue)
                    RoundButton(text: "B", color: .yellow)
                }

                RoundButton(text: "A", color: .red)
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
    static var previews: some View {
        SNESView(snes: SNES())
    }
}
