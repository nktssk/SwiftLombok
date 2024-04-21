import SwiftLombok
import Foundation

// MARK: AutoEqutable

@AutoEqutable()
struct Animal {
    let age: Int
    @AutoEqutableIgnore
    let name: String
    let onSleepAction: () -> ()
}

// MARK: AutoHashable

@AutoHashable()
struct Bump {
    let age: Int
    @AutoHashableIgnore
    let name: String
    let onSleepAction: () -> ()
}
