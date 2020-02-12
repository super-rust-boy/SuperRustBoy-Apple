//
//  C-Interop.swift
//  SuperRustBoy
//
//  Created by Sean Inge Asbjørnsen on 17/01/2020.
//  Copyright © 2020 Sean Inge Asbjørnsen. All rights reserved.
//

import Foundation

internal func bridge<T: AnyObject>(obj: T) -> UnsafeMutableRawPointer {
    UnsafeMutableRawPointer(Unmanaged.passUnretained(obj).toOpaque())
}

internal func bridge<T: AnyObject>(ptr: UnsafeMutableRawPointer) -> T {
    Unmanaged<T>.fromOpaque(ptr).takeUnretainedValue()
}
