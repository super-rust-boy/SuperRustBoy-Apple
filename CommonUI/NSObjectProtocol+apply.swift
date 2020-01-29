//
//  NSObject+apply.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 23/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import Foundation

internal extension NSObjectProtocol where Self: NSObject {
    func apply(_ apply: (Self) -> ()) -> Self {
        apply(self)
        return self
    }
}
