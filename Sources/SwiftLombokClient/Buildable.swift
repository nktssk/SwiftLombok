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

@Buildable
struct Person {
    let name: String
    let age: Int
    let hobby: String?
    let favouriteSeason: Season

    @BuildableTracked
    var likesReading: Bool

    static let minimumAge = 21
}

@Buildable
enum Season {
    case winter
    case spring
    case summer
    case autumn
}

@Buildable
class AppState {
    let persons: [Person]

    init(
        persons: [Person]
    ) {
        self.persons = persons
    }
}

var anyPerson = PersonBuilder().build()
let isReading = anyPerson.likesReading(true)
let max = PersonBuilder(name: "Max", favouriteSeason: .summer).build()
let appState = AppStateBuilder(persons: [max]).build()
