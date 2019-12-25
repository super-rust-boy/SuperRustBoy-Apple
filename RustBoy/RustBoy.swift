//
//  RustBoy.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 13/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

#if os(OSX)
import RustBoy
#endif

internal class RustBoy {

	internal enum Button {
		case left, right, up, down, a, b, start, select
#if os(OSX)
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
#endif
	}

	internal struct Cartridge {
		fileprivate let path: String
		fileprivate let saveFilePath: String?

		internal init(path: String, saveFilePath: String? = nil) {
			self.path = path
			self.saveFilePath = saveFilePath
		}
	}

	internal enum BootStatus: Error {
		case propertyMissing(name: String)
		case failedToInitCore
		case success
	}

	internal var cartridge: Cartridge? {
		didSet {
			boot()
		}
	}

	internal var display: DisplayView? {
		didSet {
			boot()
		}
	}

	internal init() {}

	internal func buttonDown(_ button: Button) {
		guard let coreRef = coreRef else { return }
#if os(OSX)
		rustBoyButtonClickDown(coreRef, button.asCoreButton)
#endif
	}

	internal func buttonUp(_ button: Button) {
		guard let coreRef = coreRef else { return }
#if os(OSX)
		rustBoyButtonClickUp(coreRef, button.asCoreButton)
#endif
	}

	private var coreRef: UnsafeRawPointer?

	internal func boot() -> BootStatus {

		guard let cart		= cartridge		else { return .propertyMissing(name: "cartridge") }
		guard let display	= display		else { return .propertyMissing(name: "display") }

#if os(OSX)
		if coreRef != nil {
			rustBoyDelete(coreRef)
		}


		guard let coreRustBoy = rustBoyCreate(Self.bridge(obj: display), cart.path, cart.saveFilePath) else { return .failedToInitCore }

		coreRef = coreRustBoy
#endif

		return .success
	}

	private static func bridge<T: AnyObject>(obj: T) -> UnsafeMutableRawPointer {
		UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
	}

	deinit {
#if os(OSX)
		if coreRef != nil {
			rustBoyDelete(coreRef)
		}
#endif
	}
}
