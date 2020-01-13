//
//  DPad.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct DPad: View {

	internal let rustBoy: RustBoy

	internal var body: some View {

		GeometryReader { geometry in
			ZStack {
                HalfPad(firstButtonType: .left, secondButtonType: .right, rustBoy: self.rustBoy)
					.frame(height: min(geometry.size.height, geometry.size.width) / 3)

                HalfPad(firstButtonType: .up, secondButtonType: .down, rustBoy: self.rustBoy)
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

fileprivate struct HalfPad: View {

	fileprivate let firstButtonType: RustBoy.ButtonType
    fileprivate let secondButtonType: RustBoy.ButtonType
	fileprivate let rustBoy: RustBoy

	fileprivate var body: some View {
		HStack {
            RustBoyButton(type: firstButtonType, rustBoy: rustBoy, content: Arrow.init)
            RustBoyButton(type: secondButtonType, rustBoy: rustBoy, content: Arrow.init)
				.rotationEffect(.degrees(180))
		}
	}
}
