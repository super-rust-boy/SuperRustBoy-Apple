//
//  RustBoyButton.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct RustBoyButton<ViewType>: View where ViewType: View {

	internal let type: RustBoy.Button
	internal let rustBoy: RustBoy
	internal let content: () -> ViewType

	@State private var touchDown: Bool = false

	internal var body: some View {

		let gesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
			.onChanged { value in
				self.touchDown = true
				self.rustBoy.buttonPressed(self.type)
			}.onEnded { value in
				self.touchDown = false
				self.rustBoy.buttonUnpressed(self.type)
			}

		return content()
			.opacity(touchDown ? 0.5 : 1)
			.gesture(gesture)
	}
}
