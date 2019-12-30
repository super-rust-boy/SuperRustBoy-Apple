//
//  NSObject+apply.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 23/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import Foundation

internal extension NSObject {
	func apply<T>(_ apply: (T) -> ()) -> T {
		let obj = self as! T
		apply(obj)
		return obj
	}
}
