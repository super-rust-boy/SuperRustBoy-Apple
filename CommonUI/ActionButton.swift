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

	internal let type: ButtonType
	@Binding var touchDown: Bool

	internal var body: some View {

		let gesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
			.onChanged { value in
				self.touchDown = true
			}.onEnded { value in
				self.touchDown = false
			}

		return ZStack {
			Circle()
				.foregroundColor(.blue)
			Text(typeString)
				.foregroundColor(.white)
		}
			.opacity(touchDown ? 0.5 : 1)
			.gesture(gesture)
	}

	private var typeString: String {
		switch type {
			case .a: return "A"
			case .b: return "B"
		}
	}

}
