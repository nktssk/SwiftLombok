import CoreGraphics

@attached(member, names: arbitrary)
public macro AutoCodingKeys(_ type: CodingKeysOption) = #externalMacro(module: "SwiftLombokMacros", type: "AutoCodingKeysMacro")

@attached(member, names: named(init), named(shared))
public macro Singleton() = #externalMacro(module: "SwiftLombokMacros", type: "SingletonMacro")

@attached(member, names: named(reuseIdentifier))
public macro ReuseIdentifier() = #externalMacro(module: "SwiftLombokMacros", type: "ReuseIdentifierMacro")

@attached(peer, names: overloaded)
public macro CompletionTransform(detachedPriority: TaskPriority? = nil) = #externalMacro(module: "SwiftLombokMacros", type: "CompletionTransformMacro")

@attached(peer, names: suffixed(Builder))
public macro Buildable() = #externalMacro(module: "SwiftLombokMacros", type: "BuildableMacroType")

@freestanding(declaration, names: arbitrary)
public macro spec(name: String, value: CGFloat) = #externalMacro(module: "SwiftLombokMacros", type: "SpecConstantMacro")

@attached(extension)
public macro AutoHashable() = #externalMacro(module: "SwiftLombokMacros", type: "AutoHashableMacro")

@attached(accessor, names: named(willSet))
public macro AutoHashableIgnore() = #externalMacro(module: "SwiftLombokMacros", type: "AutoHashableIgnoreMacro")

@attached(extension)
public macro AutoEqutable() = #externalMacro(module: "SwiftLombokMacros", type: "AutoEqutableMacro")

@attached(accessor, names: named(willSet))
public macro AutoEqutableIgnore() = #externalMacro(module: "SwiftLombokMacros", type: "AutoEqutableIgnoreMacro")

@attached(member, names: named(init), named(shared))
public macro InitCoder() = #externalMacro(module: "SwiftLombokMacros", type: "InitCoderMacro")

