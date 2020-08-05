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
	internal let content: ViewType

	internal var body: some View {
        EmulatorButton(
            content: content,
            button: type,
            onTouchDown: rustBoy.buttonPressed,
            onTouchUp: rustBoy.buttonUnpressed
        )
	}
}
