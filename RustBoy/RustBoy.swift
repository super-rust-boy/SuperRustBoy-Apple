//
//  RustBoy.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 13/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

#if os(OSX)
import AppKit
import RustBoy
import CoreVideo
#endif

internal class RustBoy {

	internal enum ButtonType {
		case left, right, up, down, a, b, start, select
	}

    internal struct Cartridge: Equatable {
		internal let path: String
		internal let saveFilePath: String
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
#if os(OSX)
        coreRustBoy?.buttonDown(button)
#endif
    }

	internal func buttonUp(_ button: ButtonType) {
#if os(OSX)
        coreRustBoy?.buttonUp(button)
#endif
    }

#if os(OSX)
    private class CoreRustBoy {

        fileprivate weak var display: DisplayView?

        fileprivate init?(cartridge: Cartridge) {
            guard let coreRef = rustBoyCreate(cartridge.path, cartridge.saveFilePath) else { return nil }
            self.coreRef = coreRef
            timer = Timer.scheduledTimer(withTimeInterval: 1 / RustBoy.framerate, repeats: true) { timer in
                rustBoyFrame(coreRef, &self.buffer, UInt32(self.buffer.count))

                let data = Data(bytes: &self.buffer, count: self.buffer.count)
                let image = NSImage(data: data)

                self.display?.image = image
            }
        }

        fileprivate func buttonDown(_ button: ButtonType) {
            rustBoyButtonClickDown(coreRef, rustBoyButton(button))
        }

        fileprivate func buttonUp(_ button: ButtonType) {
            rustBoyButtonClickUp(coreRef, rustBoyButton(button))
        }

        deinit {
            timer?.invalidate()
            rustBoyDelete(coreRef)
        }

        private let coreRef: UnsafeRawPointer
        private var timer: Timer?
        private var buffer = [UInt32](repeating: 0, count: 144 * 160)
    }

    private var coreRustBoy: CoreRustBoy?
#endif

    private static let framerate: Double = 60

	private func boot() -> BootStatus {
		guard let cart = cartridge else { return .cartridgeMissing }
#if os(OSX)
        guard let coreRustBoy = CoreRustBoy(cartridge: cart) else { return .failedToInitCore }

        self.coreRustBoy = coreRustBoy
#endif

		return .success
	}
}

#if os(OSX)
    private extension rustBoyButton {
        init(_ buttonType: RustBoy.ButtonType) {
            switch buttonType {
                case .left:     self = rustBoyButtonLeft
                case .right:    self = rustBoyButtonRight
                case .up:       self = rustBoyButtonUp
                case .down:     self = rustBoyButtonDown
                case .a:        self = rustBoyButtonA
                case .b:        self = rustBoyButtonB
                case .start:    self = rustBoyButtonStart
                case .select:   self = rustBoyButtonSelect
            }
        }
    }
#endif
