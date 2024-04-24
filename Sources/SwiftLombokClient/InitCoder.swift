import SwiftLombok

#if canImport(UIKit)

import UIKit

@InitCoder
final class View: UIView {
    
    init() {
        super.init(frame: .zero)
    }
}

#endif
