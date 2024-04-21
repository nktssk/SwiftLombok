import SwiftLombok
import Foundation

// MARK: Singleton

@Singleton
class NetworkService {
    let id = "123"
}

@Singleton
struct StorageService {
    let name = "CoreData"
}
