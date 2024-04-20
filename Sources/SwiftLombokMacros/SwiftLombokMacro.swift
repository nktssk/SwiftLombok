import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

@main
struct SwiftLombokPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        AutoCodingKeysMacro.self,
        SingletonMacro.self
    ]
}
