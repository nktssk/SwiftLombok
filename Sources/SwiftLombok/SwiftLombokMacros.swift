import CoreGraphics

@attached(member, names: arbitrary)
public macro AutoCodingKeys(_ type: CodingKeysOption) = #externalMacro(module: "SwiftLombokMacros", type: "AutoCodingKeysMacro")

@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "SwiftLombokMacros", type: "SingletonMacro")

@attached(member, names: named(reuseIdentifier))
public macro ReuseIdentifier() = #externalMacro(module: "SwiftLombokMacros", type: "ReuseIdentifierMacro")

@attached(peer, names: overloaded)
public macro CompletionTransform() = #externalMacro(module: "SwiftLombokMacros", type: "CompletionTransformMacro")

@freestanding(declaration, names: arbitrary)
public macro specConstant(name: String, value: CGFloat) = #externalMacro(module: "SwiftLombokMacros", type: "SpecConstantMacro")
