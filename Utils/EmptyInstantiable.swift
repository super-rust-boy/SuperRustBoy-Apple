//
//  EmptyInstantiable.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 23/12/2019.
//  Copyright © 2019 Sean Inge Asbjørnsen. All rights reserved.
//

import Foundation

internal protocol EmptyInstantiable {
    init()
}

extension EmptyInstantiable {
    static func setup(_ setup: (Self) -> Void) -> Self {
        let instance = Self()
        setup(instance)
        return instance
    }
}

extension NSObject: EmptyInstantiable {}
