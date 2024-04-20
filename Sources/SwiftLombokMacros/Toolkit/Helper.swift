import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftSyntax

struct MacrosHelper {
    static func getProperties(decl: StructDeclSyntax) -> [String] {
        var properties = [String]()

        for decl in decl.memberBlock.members.map(\.decl) {
            if let variableDecl = decl.as(VariableDeclSyntax.self) {
                properties.append(
                    contentsOf: variableDecl.bindings.compactMap { $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text }
                )
            }
        }

        return properties
    }
}
