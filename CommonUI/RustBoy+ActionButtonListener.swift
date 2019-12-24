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

		let button: RustBoy.Button

		switch actionButton.type {
			case .a: button = .a
			case .b: button = .b
		}

		buttonDown(button)
	}

	internal func actionButtonTouchUp(_ actionButton: ActionButton) {
		let button: RustBoy.Button

		switch actionButton.type {
			case .a: button = .a
			case .b: button = .b
		}

		buttonUp(button)
	}

}


