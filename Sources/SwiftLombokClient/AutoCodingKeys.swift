import SwiftLombok
import Foundation

// MARK: @AutoCodingKeys

@AutoCodingKeys(.snakeCase)
struct User: Codable {
    let name: String
    let password: String
    let age: Int
    let passportNumber: Double
    let averageSalary: Float
    let id: UUID
}

@AutoCodingKeys(.same)
struct User2: Codable {
    let name: String
    let password: String
    let age_3: Int
    let passportNumber: Double
    let averageSalary_4: Float
    let id: UUID
}

@AutoCodingKeys(.camelCase)
struct User3: Codable {
    let name_additional: String
    let password_plus: String
    let age_current: Int
    let passportNumber: Double
    let averageSalary: Float
    let id: UUID
}
