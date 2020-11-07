//
//  EmulatorButton.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 05/08/2020.
//

import SwiftUI

internal struct EmulatorButton<
    ViewType,
    CoreEmulator,
    Emulator: BaseEmulator<CoreEmulator>
>: View where ViewType: View {

    private let emulator: Emulator
    private let button: CoreEmulator.Button
    private let index: CoreEmulator.PlayerIndexType
    private let content: ViewType

    init(
        emulator: Emulator,
        button: CoreEmulator.Button,
        index: CoreEmulator.PlayerIndexType,
        @ViewBuilder content: () -> ViewType
    ) {
        self.emulator = emulator
        self.button = button
        self.index = index
        self.content = content()
    }

    @State
    private var touchDown: Bool = false

    internal var body: some View {
        content
            .opacity(touchDown ? 0.5 : 1)
            .gesture(
                DragGesture(minimumDistance: 0, coordinateSpace: .local)
                    .onChanged { value in
                        touchDown = true
                        emulator.buttonPressed(button, playerIndex: index)
                    }.onEnded { value in
                        touchDown = false
                        emulator.buttonUnpressed(button, playerIndex: index)
                    }
            )
    }
}
