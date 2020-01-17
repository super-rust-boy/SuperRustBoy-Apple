//
//  RustBoy.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 13/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

#if os(OSX)
import RustBoy
import CoreVideo
#endif

internal class RustBoy {

	internal enum ButtonType {
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
		fileprivate let saveFilePath: String

		internal init(path: String, saveFilePath: String) {
			self.path = path
			self.saveFilePath = saveFilePath
		}
	}

	internal enum BootStatus: Error {
        case cartridgeMissing
		case failedToInitCore
		case success
	}

	internal var cartridge: Cartridge? {
		didSet {
			let result = boot()
            assert(result == .success, "Boot failed with error: \(result)")
		}
	}

	internal var display: DisplayView?

	internal init() {}

	internal func buttonDown(_ button: ButtonType) {
		guard let coreRef = coreRef else { return }
#if os(OSX)
		rustBoyButtonClickDown(coreRef, button.asCoreButton)
#endif
	}

	internal func buttonUp(_ button: ButtonType) {
		guard let coreRef = coreRef else { return }
#if os(OSX)
		rustBoyButtonClickUp(coreRef, button.asCoreButton)
#endif
	}

    internal func frame(buffer: inout [UInt32]) {
        rustBoyFrame(coreRef, &buffer, UInt32(buffer.count))
    }

	private var coreRef: UnsafeRawPointer?
    private var timer: Timer?
    private static let framerate: Double = 60

    private var buffer = [UInt32](repeating: 0, count: 144 * 160)

	private func boot() -> BootStatus {

		guard let cart = cartridge else { return .cartridgeMissing }

#if os(OSX)
		if coreRef != nil {
			rustBoyDelete(coreRef)
		}


		guard let coreRustBoy = rustBoyCreate(cart.path, cart.saveFilePath) else { return .failedToInitCore }

		coreRef = coreRustBoy

        timer = Timer.scheduledTimer(withTimeInterval: 1 / Self.framerate, repeats: true) { [weak self] timer in

            guard let weakSelf = self else {
                print("Failed to capture self")
                return
            }

            weakSelf.frame(buffer: &weakSelf.buffer)

//            print("Buffer: \(weakSelf.buffer)")
        }
#endif

		return .success
	}

	deinit {
#if os(OSX)
		if coreRef != nil {
			rustBoyDelete(coreRef)
		}
#endif
	}
}
