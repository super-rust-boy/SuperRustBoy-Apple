//
//  ContentView.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 13/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
		VStack {
			Color.red
			HStack {
				DPad()
					.padding()
				HStack {
					ActionButton(type: .b)
					ActionButton(type: .a)
				}
					.padding()
			}
		}
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
			.frame(width: 300, height: 500)
    }
}
