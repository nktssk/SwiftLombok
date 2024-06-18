import SwiftSyntax

struct MockedClassDeclarationBuilder {
    func build(typeName: TokenSyntax, from classDecl: ClassDeclSyntax) -> ClassDeclSyntax {
        ClassDeclSyntax(
            name: typeName,
            memberBlockBuilder: {
                let properties = classDecl.memberBlock.members
                    .compactMap { $0.decl.as(VariableDeclSyntax.self) }
                MockPropertyDeclarationBuilder().createMockPropertyDeclarations(properties)

                let methods = classDecl.memberBlock.members
                    .compactMap { $0.decl.as(FunctionDeclSyntax.self) }

                let methodsBuilder = MockFunctionDeclarationBuilder()
                methodsBuilder.createCallTrackerDeclarations(methods)
                methodsBuilder.createMockImplementations(for: methods)
            }
        )
    }
}