import SwiftLombok
import Foundation

// MARK: - AutoCodingKeys

@AutoCodingKeys(.snakeCase)
struct User3: Codable {
    let name: String
    let password: String
    let age: Int
    let passportNumber: Double
    let averageSalary: Float
    let id: UUID
}

@AutoCodingKeys(.same)
struct User: Codable {
    let name: String
    let password: String
    let age_3: Int
    let passportNumber: Double
    let averageSalary_4: Float
    let id: UUID
}

@AutoCodingKeys(.camelCase)
struct User2: Codable {
    let name_additional: String
    let password_plus: String
    let age_current: Int
    let passportNumber: Double
    let averageSalary: Float
    let id: UUID
}

// MARK: - Singleton

@Singleton
class NetworkService {
    let id = "123"
}

@Singleton
struct StorageService {
    let name = "CoreData"
}

print(NetworkService.shared.id)
print(StorageService.shared.name)

// MARK: - Async

@CompletionTransform
func loadUser(by userID: UUID) async -> User {
    try? await Task.sleep(nanoseconds: 1_000_000)
    return User(name: "123", password: "123", age_3: 3, passportNumber: 3, averageSalary_4: 3, id: UUID())
}

//Task {
//    await loadUser(by: UUID())
//}

loadUser(
    by: UUID(),
    completionHandler: { user in
        print(user)
    }
)

// MARK: - ReuseIdentifier

@ReuseIdentifier
class CustomCollectionCell {
    
}

print(CustomCollectionCell.reuseIdentifier)

// MARK: - Hashable

//enum Spec {
//    static let test: CGFloat = 10
//}

enum Spec {
    #specConstant(name: "test", value: 10)
}
