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
				HalfPad(types: (.left, .right), rustBoy: self.rustBoy)
					.frame(height: min(geometry.size.height, geometry.size.width) / 3)
				HalfPad(types: (.up, .down), rustBoy: self.rustBoy)
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

	fileprivate let types: (RustBoy.ButtonType, RustBoy.ButtonType)
	fileprivate let rustBoy: RustBoy

	fileprivate var body: some View {
		HStack {
			RustBoyButton(type: types.0, rustBoy: rustBoy, bodyView: AnyView(Arrow()))
			RustBoyButton(type: types.1, rustBoy: rustBoy, bodyView: AnyView(Arrow()))
				.rotationEffect(.degrees(180))
		}
	}
}
