//
//  DPad.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 19/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

internal struct DPad: View {

	var body: some View {

		GeometryReader { geometry in

			Path { path in

				let size = min(geometry.size.width, geometry.size.height)

				let sizeOverThree = size / 3

				path.move(to: CGPoint(x: sizeOverThree, y: 0))
				path.addLine(to: CGPoint(x: sizeOverThree * 2, y: 0))
				path.addLine(to: CGPoint(x: sizeOverThree * 2, y: size))
				path.addLine(to: CGPoint(x: sizeOverThree, y: size))

				path.move(to: CGPoint(x: 0, y: sizeOverThree))
				path.addLine(to: CGPoint(x: size, y: sizeOverThree))
				path.addLine(to: CGPoint(x: size, y: sizeOverThree * 2))
				path.addLine(to: CGPoint(x: 0, y: sizeOverThree * 2))
			}
			.frame(width: min(geometry.size.width, geometry.size.height), height: min(geometry.size.width, geometry.size.height))
		}
	}

}

struct DPad_Previews: PreviewProvider {
	static var previews: some View {
		DPad()
			.frame(width: 300, height: 600)
	}
}



