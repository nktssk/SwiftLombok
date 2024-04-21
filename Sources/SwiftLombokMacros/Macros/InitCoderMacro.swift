import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum InitCoderMacroError: Error {
    case notSupportedType
}

public struct InitCoderMacro: MemberMacro {
    
    static let supportedTypes: [SwiftSyntax.SyntaxKind] = [.classDecl, .structDecl]
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let nameOfDecl = declaration.as(ClassDeclSyntax.self)
        let selfToken: TokenSyntax = "\(raw: nameOfDecl)()"
        
        return [
            DeclSyntax(try InitializerDeclSyntax("required init?(coder: NSCoder)") {
                "fatalError(\"init(coder:) has not been implemented\")"
            }),
        ]
    }
}
