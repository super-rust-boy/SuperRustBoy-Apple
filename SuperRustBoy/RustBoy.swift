//
//  RustBoy.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 13/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import RustBoy

internal class RustBoy {
	internal init(cartridgePath: String, saveFilePath: String) {
		coreRef = rustBoyCreate(cartridgePath, saveFilePath)
	}

	private let coreRef: UnsafeRawPointer
}
