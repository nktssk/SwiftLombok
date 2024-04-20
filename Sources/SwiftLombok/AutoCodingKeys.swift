@attached(member, names: arbitrary)
public macro AutoCodingKeys(_ type: CodingKeysOption) = #externalMacro(module: "SwiftLombokMacros", type: "AutoCodingKeysMacro")

@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "SwiftLombokMacros", type: "SingletonMacro")
