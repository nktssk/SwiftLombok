import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public enum AutoEqutableMacroError: Error {
    case notSupportedType
}

public struct AutoEqutableMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard [SwiftSyntax.SyntaxKind.classDecl, SwiftSyntax.SyntaxKind.structDecl].contains(declaration.kind) else {
            throw AutoEqutableMacroError.notSupportedType
        }
        let equatableProtocol = InheritanceClauseSyntax(inheritedTypes: InheritedTypeListSyntax(
            arrayLiteral: InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "Equatable")))
        )
        
        let members = declaration.memberBlock.members
            .compactMap { member in
                guard
                    let varDecl = member.decl.as(VariableDeclSyntax.self),
                    let patternBinding = varDecl.bindings.as(PatternBindingListSyntax.self)?.first?.as(PatternBindingSyntax.self),
                    let identifier = patternBinding.pattern.as(IdentifierPatternSyntax.self)?.identifier,
                    let type =  patternBinding.typeAnnotation?.as(TypeAnnotationSyntax.self)?.type
                else { return nil }
                
                let currentAttributeNames = varDecl.attributes.compactMap {
                    if case let .attribute(att) = $0 { att.attributeName.trimmedDescription } else { nil }
                }
                if currentAttributeNames.contains("AutoEqutableIgnore") {
                    return nil
                }
                
                if type.is(IdentifierTypeSyntax.self) {
                    return "lhs.\(identifier) == rhs.\(identifier)"
                }
                if let wrappedType = type.as(OptionalTypeSyntax.self)?.wrappedType,
                   wrappedType.is(IdentifierTypeSyntax.self) {
                    return "lhs.\(identifier) == rhs.\(identifier)"
                }
                
                return nil
            }
            .joined(separator: "\n    && ")
        
        let equtableFunction = """
        static func == (lhs: \(type), rhs: \(type)) -> Bool {
            \(members)
        }
        """
        
        return [
            ExtensionDeclSyntax(
                extendedType: type,
                inheritanceClause: equatableProtocol,
                memberBlock: MemberBlockSyntax(
                    members: MemberBlockItemListSyntax(stringLiteral: equtableFunction)
                )
            )
        ]
    }
}

public struct AutoEqutableIgnoreMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        []
    }
}
