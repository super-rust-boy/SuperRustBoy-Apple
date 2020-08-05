//
//  DPad.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct DPad: View {

    enum Direction {
        case left, up, right, down
    }

    internal let onTouchDown: (Direction) -> Void
    internal let onTouchUp: (Direction) -> Void

	internal var body: some View {

		GeometryReader { geometry in
			ZStack {
                HalfPad(
                    firstButtonType: .left,
                    secondButtonType: .right,
                    onTouchDown: onTouchDown,
                    onTouchUp: onTouchUp
                )
                .frame(height: min(geometry.size.height, geometry.size.width) / 3)

                HalfPad(
                    firstButtonType: .up,
                    secondButtonType: .down,
                    onTouchDown: onTouchDown,
                    onTouchUp: onTouchUp
                )
                .frame(height: min(geometry.size.height, geometry.size.width) / 3)
					.rotationEffect(.degrees(90))
			}
            .frame(
                width:	min(geometry.size.height, geometry.size.width),
                height:	min(geometry.size.height, geometry.size.width)
            )
		}
	}

}

fileprivate struct HalfPad<Button>: View {

	fileprivate let firstButtonType: Button
    fileprivate let secondButtonType: Button

    fileprivate let onTouchDown: (Button) -> Void
    fileprivate let onTouchUp: (Button) -> Void

	fileprivate var body: some View {
		HStack {
            EmulatorButton(
                content: Arrow(),
                button: firstButtonType,
                onTouchDown: onTouchDown,
                onTouchUp: onTouchUp
            )

            EmulatorButton(
                content: Arrow(),
                button: secondButtonType,
                onTouchDown: onTouchDown,
                onTouchUp: onTouchUp
            )
            .rotationEffect(.degrees(180))
		}
	}
}
