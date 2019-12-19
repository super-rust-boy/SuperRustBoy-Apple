//
//  RustBoy.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 13/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import RustBoy

internal class RustBoy {

	internal enum Button {
		case left, right, up, down, a, b, start, select

		fileprivate var asCoreButton: rustBoyButton {
			switch self {
				case .left:		return rustBoyButtonLeft
				case .right:	return rustBoyButtonRight
				case .up:		return rustBoyButtonUp
				case .down:		return rustBoyButtonDown
				case .a:		return rustBoyButtonA
				case .b:		return rustBoyButtonB
				case .start:	return rustBoyButtonStart
				case .select:	return rustBoyButtonSelect
			}
		}
	}

	internal init?(cartridgePath: String, saveFilePath: String) {
		guard let ref = rustBoyCreate(cartridgePath, saveFilePath) else { return nil }
		coreRef = ref
	}

	internal func buttonDown(_ button: Button) {
		rustBoyButtonClickDown(coreRef, button.asCoreButton)
	}

	internal func buttonUp(_ button: Button) {
		rustBoyButtonClickUp(coreRef, button.asCoreButton)
	}

	private let coreRef: UnsafeRawPointer

	deinit {
		rustBoyDelete(coreRef)
	}
}
