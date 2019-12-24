//
//  RustBoyView.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 23/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct RustBoyView: View {

	private let rustBoy: RustBoy

	internal var body: some View {
		VStack {
			Display(rustBoy: rustBoy)
			HStack {
				DPad()
					.padding()
				HStack {
					ActionButton(type: .b, listener: rustBoy)
					ActionButton(type: .a, listener: rustBoy)
				}
				.padding()
			}
		}
	}

	internal init(rustBoy: RustBoy) {
		self.rustBoy = rustBoy
	}

}
