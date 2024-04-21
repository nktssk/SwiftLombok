import SwiftLombok
import Foundation

// MARK: SpecConstants

enum OldSpec {
    static let test: CGFloat = 10
}

enum Spec {
    #spec(name: "test", value: 10)
}


#if canImport(UIKit)

import UIKit

@InitCoder
final class View: UIView {
    
    init() {
        super.init(frame: .zero)
    }
}

#endif
