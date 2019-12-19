//
//  ActionButton.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct ActionButton: View {

	internal enum ButtonType {
		case a, b
	}

	internal var body: some View {
		ZStack {
			Circle()
				.foregroundColor(.blue)
			Text(typeString)
		}
	}

	internal init(type: ButtonType) {
		self.type = type
	}

	private let type: ButtonType
	private var typeString: String {
		switch type {
			case .a: return "A"
			case .b: return "B"
		}
	}

}
