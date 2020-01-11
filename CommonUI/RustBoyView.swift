//
//  RustBoyView.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 23/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct RustBoyView: View {

	internal let rustBoy: RustBoy

	internal var body: some View {
		VStack {
			Display(rustBoy: rustBoy)

			HStack {
				DPad(rustBoy: rustBoy)
					.padding()
				HStack {
                    RustBoyButton(type: .b, rustBoy: rustBoy) { RoundButton(text: "B") }
                    RustBoyButton(type: .a, rustBoy: rustBoy) { RoundButton(text: "A") }
				}
				.padding()
			}

			GeometryReader { geometry in
				HStack {
                    VStack {
                        RustBoyButton(type: .select, rustBoy: self.rustBoy) { RoundedRectangle(cornerRadius: 25) }
                        Text("Select")
                    }
					VStack {
                        RustBoyButton(type: .start, rustBoy: self.rustBoy) { RoundedRectangle(cornerRadius: 25) }
						Text("Start")
					}
				}
					.frame(width: geometry.size.width / 3)
			}
				.frame(height: 50)
				.padding()
		}
	}
}
