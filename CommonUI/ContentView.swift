//
//  ContentView.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 13/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

struct ContentView: View {

	@State private var buttonDownB: Bool = false
	@State private var buttonDownA: Bool = false

    var body: some View {
		VStack {
			Display()
			HStack {
				DPad()
					.padding()
				HStack {
					ActionButton(type: .b, touchDown: $buttonDownB)
					ActionButton(type: .a, touchDown: $buttonDownA)
				}
					.padding()
			}
		}
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
