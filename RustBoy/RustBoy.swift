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

	internal enum BootStatus: Error {
		case propertyMissing(name: String)
		case failedToInitCore
		case success
	}

	internal var cartridgePath:	String? {
		didSet {
			boot()
		}
	}

	internal var saveFilePath:	String? {
		didSet {
			boot()
		}
	}

	internal var display:		DisplayView? {
		didSet {
			boot()
		}
	}

	internal init() {}

	internal func buttonDown(_ button: Button) {
		guard let coreRef = coreRef else { return }
		rustBoyButtonClickDown(coreRef, button.asCoreButton)
	}

	internal func buttonUp(_ button: Button) {
		guard let coreRef = coreRef else { return }
		rustBoyButtonClickUp(coreRef, button.asCoreButton)
	}

	private var coreRef: UnsafeRawPointer?

	internal func boot() -> BootStatus {

		guard let cartPath	= cartridgePath	else { return .propertyMissing(name: "cartridgePath") }
		guard let savePath	= saveFilePath	else { return .propertyMissing(name: "saveFilePath") }
		guard let display	= display		else { return .propertyMissing(name: "display") }

		if coreRef != nil {
			rustBoyDelete(coreRef)
		}

		guard let coreRustBoy = rustBoyCreate(Self.bridge(obj: display), cartPath, savePath) else { return .failedToInitCore }

		coreRef = coreRustBoy

		return .success
	}

	private static func bridge<T: AnyObject>(obj: T) -> UnsafeMutableRawPointer {
		UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
	}

	deinit {
		if coreRef != nil {
			rustBoyDelete(coreRef)
		}
	}
}
