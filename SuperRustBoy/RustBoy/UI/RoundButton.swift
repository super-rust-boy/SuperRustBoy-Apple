//
//  RoundButton.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 04/01/2020.
//  Copyright © 2020 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct RoundButton: View {

	internal let text: String

	internal var body: some View {
		ZStack {
			Circle()
				.foregroundColor(.blue)
			Text(text)
				.foregroundColor(.white)
		}
	}
}
