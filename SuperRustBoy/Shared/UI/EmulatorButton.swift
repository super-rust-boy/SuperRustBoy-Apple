//
//  EmulatorButton.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 05/08/2020.
//

import SwiftUI

internal struct EmulatorButton<ViewType, ButtonType>: View where ViewType: View {

    internal let content: ViewType
    internal let button: ButtonType
    internal let onTouchDown: (ButtonType) -> Void
    internal let onTouchUp: (ButtonType) -> Void

    @State
    private var touchDown: Bool = false

    internal var body: some View {

        let gesture = DragGesture(minimumDistance: 0, coordinateSpace: .local)
            .onChanged { value in
                self.touchDown = true
                self.onTouchDown(button)
            }.onEnded { value in
                self.touchDown = false
                self.onTouchUp(button)
            }

        return content
            .opacity(touchDown ? 0.5 : 1)
            .gesture(gesture)
    }
}
