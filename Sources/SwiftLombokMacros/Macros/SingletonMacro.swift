import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum SingletonMacroError: Error {
    case notSupportedType
}

public struct SingletonMacro: MemberMacro {
    
    static let supportedTypes: [SwiftSyntax.SyntaxKind] = [.classDecl, .structDecl]
    
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let nameOfDecl = try name(providingMembersOf: declaration).text
        
        let selfToken: TokenSyntax = "\(raw: nameOfDecl)()"
        let initShared = FunctionCallExprSyntax(calledExpression: DeclReferenceExprSyntax(baseName: selfToken)) {}
        let sharedInitializer = InitializerClauseSyntax(
            equal: .equalToken(trailingTrivia: .space),
            value: initShared
        )
        
        let staticModifier = DeclModifierSyntax(name: "static")
        let modifiers: DeclModifierListSyntax
        let isPublicACL = declaration.modifiers.map(\.name.text).contains("public")
        if isPublicACL {
            let publicToken: TokenSyntax = "public"
            let publicModifier = DeclModifierSyntax(name: publicToken)
            modifiers = DeclModifierListSyntax([publicModifier] + [staticModifier])
        } else {
            modifiers = DeclModifierListSyntax([staticModifier])
        }
        
        let shared = VariableDeclSyntax(
            modifiers: modifiers,
            .let, name: "shared",
            initializer: sharedInitializer
        )
        return [
            DeclSyntax(shared),
            DeclSyntax(try InitializerDeclSyntax("private init()") {}),
        ]
    }
}

private extension SingletonMacro {
    static func name(providingMembersOf declaration: some DeclGroupSyntax) throws -> TokenSyntax {
        if let classDecl = declaration.as(ClassDeclSyntax.self) {
            classDecl.name
        } else if let structDecl = declaration.as(StructDeclSyntax.self) {
            structDecl.name
        } else {
            throw SingletonMacroError.notSupportedType
        }
    }
}
