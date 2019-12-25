//
//  RustBoy+ActionButtonViewModel.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 24/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import Foundation

extension RustBoy: ActionButtonListener {

	internal func actionButtonTouchDown(_ actionButton: ActionButton) {
		buttonDown(actionButton.toRustBoyButton())
	}

	internal func actionButtonTouchUp(_ actionButton: ActionButton) {
		buttonUp(actionButton.toRustBoyButton())
	}

}

fileprivate extension ActionButton {
	func toRustBoyButton() -> RustBoy.Button {
		let button: RustBoy.Button

		switch self.type {
			case .a: button = .a
			case .b: button = .b
		}

		return button
	}
}


