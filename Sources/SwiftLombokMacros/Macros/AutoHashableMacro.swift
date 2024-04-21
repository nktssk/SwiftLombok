import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public enum AutoHashbleMacroError: Error {
    case notSupportedType
}

public struct AutoHashableMacro: ExtensionMacro {
    public static func expansion(
        of node: SwiftSyntax.AttributeSyntax,
        attachedTo declaration: some SwiftSyntax.DeclGroupSyntax,
        providingExtensionsOf type: some SwiftSyntax.TypeSyntaxProtocol,
        conformingTo protocols: [SwiftSyntax.TypeSyntax],
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.ExtensionDeclSyntax] {
        guard [SwiftSyntax.SyntaxKind.classDecl, SwiftSyntax.SyntaxKind.structDecl].contains(declaration.kind) else {
            throw AutoHashbleMacroError.notSupportedType
        }
        let hashableProtocol = InheritanceClauseSyntax(inheritedTypes: InheritedTypeListSyntax(
            arrayLiteral: InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "Hashable")))
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

                if currentAttributeNames.contains("AutoHashableIgnore") {
                    return nil
                }

                return "hasher.combine(\(identifier))"
            }
            .joined(separator: "\n")
        
        let function = """
        func hash(into hasher: inout Hasher) {
            \(members)
        }
        """
        
        return [
            ExtensionDeclSyntax(
                extendedType: type,
                inheritanceClause: hashableProtocol,
                memberBlock: MemberBlockSyntax(
                    members: MemberBlockItemListSyntax(stringLiteral: function)
                )
            )
        ]
    }
}

public struct AutoHashableIgnoreMacro: AccessorMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingAccessorsOf declaration: some DeclSyntaxProtocol,
        in context: some MacroExpansionContext
    ) throws -> [AccessorDeclSyntax] {
        []
    }
}
