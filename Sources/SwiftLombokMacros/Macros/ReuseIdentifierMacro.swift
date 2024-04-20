import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum ReuseIdentifierError: Error {
    case notSupportedType
}

public struct ReuseIdentifierMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        guard let classDecl = declaration.as(ClassDeclSyntax.self) else {
            throw ReuseIdentifierError.notSupportedType
        }

        let reuseID = try VariableDeclSyntax("static var reuseIdentifier: String") {
            StringLiteralExprSyntax(content: classDecl.name.text)
        }

        return [
            DeclSyntax(reuseID)
        ]
    }
}
