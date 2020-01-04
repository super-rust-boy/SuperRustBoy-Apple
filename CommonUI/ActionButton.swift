//
//  ActionButton.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct ActionButton: View {

	internal let type: RustBoy.Button
	internal let rustBoy: RustBoy
	internal let bodyView: AnyView

	@State private var touchDown: Bool = false

	internal var body: some View {

		let gesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
			.onChanged { value in
				self.touchDown = true
				self.rustBoy.buttonDown(self.type)
			}.onEnded { value in
				self.touchDown = false
				self.rustBoy.buttonUp(self.type)
			}

		return bodyView
			.opacity(touchDown ? 0.5 : 1)
			.gesture(gesture)
	}
}
