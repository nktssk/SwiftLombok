import SwiftLombok
import Foundation

// MARK: ReuseIdentifier

@ReuseIdentifier
final class CustomCollectionCell {
    private var data: String = ""
    
    func layout() {}
    func setViewData(_ data: String) { self.data = data }
}

func sandbox_reuseIdentifier() {
    print(CustomCollectionCell.reuseIdentifier)
}
