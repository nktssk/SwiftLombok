import SwiftLombok
import Foundation

// MARK: Async

@CompletionTransform(detachedPriority: .low)
func loadUser(by userID: UUID) async -> User {
    try? await Task.sleep(nanoseconds: 1_000_000)
    return User(name: "123", password: "123", age: 3, passportNumber: 3, averageSalary: 3, id: UUID())
}

func test() {
    
}
