import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct SwiftLombokPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoCodingKeysMacro.self,
        AutoEqutableMacro.self,
        AutoEqutableIgnoreMacro.self,
        AutoHashableMacro.self,
        AutoHashableIgnoreMacro.self,
        
        SingletonMacro.self,
        CompletionTransformMacro.self,

        BuildableMacroType.self,
        BuildableTrackedMacro.self,

        ReuseIdentifierMacro.self,
        SpecConstantMacro.self,
        InitCoderMacro.self
    ]
}
