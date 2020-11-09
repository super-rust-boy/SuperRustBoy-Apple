//
//  Arrow.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 04/01/2020.
//  Copyright © 2020 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct Arrow: Shape {

	internal func path(in rect: CGRect) -> Path {

		let oneThirdWidth	= rect.width / 3
		let twoThirdsWidth	= oneThirdWidth * 2

		var path = Path()

		path.move(to: .zero)

		path.addLine(to: CGPoint(x: twoThirdsWidth, y: 0))
		path.addLine(to: CGPoint(x: rect.width, y: rect.height * 0.5))
		path.addLine(to: CGPoint(x: twoThirdsWidth, y: rect.height))
		path.addLine(to: CGPoint(x: 0, y: rect.height))

		return path
	}
}

struct Arrow_Previews: PreviewProvider {
    static var previews: some View {
        Arrow()
            .frame(width: 100, height: 50)
            .previewLayout(.sizeThatFits)
            .padding()
    }
}
