//
//  Buildable.swift
//
//
//  Created by r.latypov on 21.04.2024.
//

import SwiftLombok
import Foundation

// MARK: Buildable

@Buildable
enum MyEnum {
    case `none`
    case myCase
}

@Buildable
class MyClass {
    var m1: String = ""

    init(
        m1: String
    ) {
        self.m1 = m1
    }
}

@Buildable
struct MyStruct {
    let m1: String
    let fix: String = ""
}
