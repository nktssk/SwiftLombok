import SwiftLombok
import Foundation

// MARK: SpecConstants

enum OldSpec {
    static let test: CGFloat = 10
}

enum Spec {
    #spec(name: "test", value: 10)
}
