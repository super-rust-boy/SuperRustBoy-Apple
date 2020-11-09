//
//  RoundButton.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 04/01/2020.
//  Copyright © 2020 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct RoundButton: View {

	internal let text: String
    internal let color: Color

    init(text: String, color: Color = .blue) {
        self.text = text
        self.color = color
    }

	internal var body: some View {
		ZStack {
			Circle()
				.foregroundColor(color)
			Text(text)
				.foregroundColor(.white)
		}
	}
}

struct RoundButton_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            RoundButton(text: "X", color: .green)
            RoundButton(text: "Y", color: .blue)
            RoundButton(text: "A", color: .yellow)
            RoundButton(text: "B", color: .red)
        }
        .previewLayout(.sizeThatFits)
    }
}
