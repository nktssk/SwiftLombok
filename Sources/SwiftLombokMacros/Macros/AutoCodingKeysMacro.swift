import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public enum AutoCodingKeysError: Error {
    case invalidDeclarationSyntax
    case noOptions
}

public struct AutoCodingKeysMacro: MemberMacro {
    public static func expansion<Declaration: DeclGroupSyntax, Context: MacroExpansionContext>(
        of node: AttributeSyntax,
        providingMembersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard let structDecl = declaration.as(StructDeclSyntax.self) else {
            throw AutoCodingKeysError.invalidDeclarationSyntax
        }
        
        guard case let .argumentList(arguments) = node.arguments,
              let firstElement = arguments.first?.expression,
              let memberAccessExpr = firstElement.as(MemberAccessExprSyntax.self),
              let option = CodingKeysOption(rawValue: memberAccessExpr.declName.trimmedDescription)
        else {
            throw AutoCodingKeysError.noOptions
        }
        
        var properties = [String]()

        for decl in structDecl.memberBlock.members.map(\.decl) {
            if let variableDecl = decl.as(VariableDeclSyntax.self) {
                properties.append(
                    contentsOf: variableDecl.bindings.compactMap { $0.pattern.as(IdentifierPatternSyntax.self)?.identifier.text }
                )
            }
        }
        
        let enumSyntax = EnumDeclSyntax(
            identifier: .identifier("CodingKeys"),
            inheritanceClause: InheritanceClauseSyntax {
                InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "String"))
                InheritedTypeSyntax(type: TypeSyntax(stringLiteral: "CodingKey"))
            }
        ) {
            MemberBlockItemListSyntax(
                properties.map { property in
                    MemberBlockItemSyntax(
                        decl: EnumCaseDeclSyntax(
                            elements: EnumCaseElementListSyntax(
                                arrayLiteral: EnumCaseElementSyntax(
                                    name: .identifier(property),
                                    rawValue: InitializerClauseSyntax(
                                        equal: .equalToken(),
                                        value: StringLiteralExprSyntax(content: {
                                            switch option {
                                            case .same:
                                                return property
                                            case .camelCase:
                                                return property.toCamelCase()
                                            case .snakeCase:
                                                return property.toSnakeCase()
                                            }
                                            
                                        }())
                                    )
                                )
                            )
                        )
                    )
                }
            )
        }
        
        return [
            DeclSyntax(enumSyntax)
        ]
    }
    
    public static func generateDefaultCodingKeys(_ structDecSyntax: StructDeclSyntax) -> [DeclSyntax] {
        let members = structDecSyntax.memberBlock.members
        let variableDecl = members.compactMap { $0.decl.as(VariableDeclSyntax.self)?.bindings }
        let variables = variableDecl.compactMap({$0.first?.pattern})
        let parameters = variables
            .map { variable in
                return  "case \(variable)"
            }
            .joined(separator: "\n")
        
        return [
                """
                enum CodingKeys: String, CodingKey {
                    \(raw: parameters)
                }
                """
        ]
    }
    
    private static func diagnoseInvalidOptions(
        option: CodingKeysOption,
        properties: [String],
        declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) -> Bool {
        switch option {
        case .same, .camelCase, .snakeCase:
            return true
        }
    }
}
