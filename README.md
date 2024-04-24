# SwiftLombok 
This is a Swift library dedicated to macros, a new language feature in Swift. Macros simplify code writing, improve readability, and enhance development productivity.

### Features

- Provides various macros to simplify routine tasks in Swift development.
- Enhances code readability and reduces redundant code.
- Supports multiple platforms including iOS, macOS, watchOS, and tvOS.
- Easily integrates into your project via Swift Package Manager (SPM) or manual installation.

### Macro

### Macro

1. **AutoEqutable**
   Automatically generates the `Equatable` protocol conformance for a Swift struct or class.

2. **AutoHashable**
   Automatically generates the `Hashable` protocol conformance for a Swift struct or class.

3. **ReuseIdentifier**
   Generates a static property `reuseIdentifier` for a Swift class or struct, commonly used in iOS for dequeueing reusable views.

4. **Singleton**
   Creates a singleton instance of a Swift class.

5. **InitCoder**
   Automatically generates the `init?(coder:)` initializer required for NSCoding conformance in Swift classes.

6. **Buildable**
   Facilitates the building of complex objects in Swift by providing a fluent interface for configuring properties.

7. **AutoCodingKeys**
   Automatically generates `CodingKeys` enumeration for Swift structs or classes when using Codable protocol. You can choose - camel or snake case.

8. **#spec**
   Create CGFloat static let constant.


### Usage

You can find usage examples in the SwiftLombokClient folder.

### Installation
How to integrate SwiftLombok into your project via SPM:

1. File > Swift Packages > Add Package Dependency
1. Add https://github.com/nktssk/SwiftLombok.git"
1. Select "Up to Next Major" with "1.0.0"

Or add this code to your project:
```Swift
let package = Package(
    dependencies: [
        .package(url: "https://github.com/nktssk/SwiftLombok.git", from: "1.0.0")
    ]
)
```