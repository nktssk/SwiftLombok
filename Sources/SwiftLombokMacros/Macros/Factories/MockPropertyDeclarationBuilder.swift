import SwiftSyntax
import SwiftSyntaxBuilder

struct MockPropertyDeclarationBuilder {
    @MemberBlockItemListBuilder
    func createMockPropertyDeclarations(_ properties: [VariableDeclSyntax]) -> MemberBlockItemListSyntax {
        for property in properties {
            createMockPropertyDeclaration(property)
        }
    }

    @MemberBlockItemListBuilder
    func createMockPropertyDeclaration(_ property: VariableDeclSyntax) -> MemberBlockItemListSyntax {
        if let binding = property.bindings.first, let type = binding.typeAnnotation?.type.description {
            VariableDeclSyntax(
                bindingSpecifier: .keyword(.var),
                bindings: .init(
                    arrayLiteral: PatternBindingSyntax(
                        pattern: binding.pattern,
                        typeAnnotation: TypeAnnotationSyntax(type: TypeSyntax(stringLiteral: "MockVariable<\(type)>")),
                        initializer: InitializerClauseSyntax(value: ExprSyntax(stringLiteral: ".init()")))
                )
            )
        }
    }
}
