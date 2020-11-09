//
//  DPad.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct DPad<CoreEmulator, Emulator: BaseEmulator<CoreEmulator>>: View {

    internal enum Direction {
        case left, up, right, down
    }

    internal let emulator: Emulator?
    internal let index: CoreEmulator.PlayerIndexType
    internal let direction: (Direction) -> CoreEmulator.Button

	internal var body: some View {
		GeometryReader { geometry in
			ZStack {
                HalfPad(
                    emulator: emulator,
                    firstButtonType: direction(.left),
                    secondButtonType: direction(.right),
                    index: index
                )
                .frame(height: min(geometry.size.height, geometry.size.width) / 3)

                HalfPad(
                    emulator: emulator,
                    firstButtonType: direction(.up),
                    secondButtonType: direction(.down),
                    index: index
                )
                .frame(height: min(geometry.size.height, geometry.size.width) / 3)
                .rotationEffect(.degrees(90))
			}
            .frame(
                width: min(geometry.size.height, geometry.size.width),
                height: min(geometry.size.height, geometry.size.width)
            )
            .position(
                x: geometry.size.width * 0.5,
                y: geometry.size.height * 0.5
            )
		}
    }
}

fileprivate struct HalfPad<CoreEmulator, Emulator: BaseEmulator<CoreEmulator>>: View {

    fileprivate let emulator: Emulator?
    fileprivate let firstButtonType: CoreEmulator.Button
    fileprivate let secondButtonType: CoreEmulator.Button
    fileprivate let index: CoreEmulator.PlayerIndexType

	fileprivate var body: some View {
		HStack {
            EmulatorButton(emulator: emulator, button: firstButtonType, index: index) {
                Arrow()
            }

            EmulatorButton(emulator: emulator, button: secondButtonType, index: index) {
                Arrow()
            }
            .rotationEffect(.degrees(180))
		}
	}
}

struct DPad_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(ColorScheme.allCases, id: \.hashValue) { theme in
            DPad(emulator: Optional<SNES>.none, index: .player1, direction: SNES.Button.init)
                .frame(width: 200, height: 500)
                .previewLayout(.sizeThatFits)
                .environment(\.colorScheme, theme)
                .background(theme == .dark ? Color.black : Color.white)
        }
    }
}
