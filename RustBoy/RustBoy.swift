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
		case propertyMissing(name: String)
		case failedToInitCore
		case success
	}

	internal var cartridge: Cartridge? {
		didSet {
			boot()
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
    private var displayLink: CVDisplayLink?

	private func boot() -> BootStatus {

		guard let cart = cartridge else { return .propertyMissing(name: "cartridge") }

#if os(OSX)
		if coreRef != nil {
			rustBoyDelete(coreRef)
		}


		guard let coreRustBoy = rustBoyCreate(cart.path, cart.saveFilePath) else { return .failedToInitCore }

		coreRef = coreRustBoy
#endif

        CVDisplayLinkCreateWithActiveCGDisplays(&displayLink)

        CVDisplayLinkSetOutputCallback(displayLink!, displayCallback, bridge(obj: self))

        CVDisplayLinkStart(displayLink!)

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

private let displayCallback: CVDisplayLinkOutputCallback = { (displayLink: CVDisplayLink, inNow: UnsafePointer<CVTimeStamp>, inOutputTime: UnsafePointer<CVTimeStamp>, flagsIn: CVOptionFlags, flagsOut: UnsafeMutablePointer<CVOptionFlags>, userData: UnsafeMutableRawPointer?) -> CVReturn in

    DispatchQueue.main.async {
        let rustBoy: RustBoy = bridge(ptr: userData!)

        var buffer = [UInt32](repeating: 0, count: 144 * 160)

        rustBoy.frame(buffer: &buffer)
    }

    return .zero
}

private func bridge<T: AnyObject>(obj: T) -> UnsafeMutableRawPointer {
    UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

private func bridge< T:AnyObject >( ptr: UnsafeMutableRawPointer ) -> T {
    return Unmanaged< T >.fromOpaque( ptr ).takeUnretainedValue()
}
