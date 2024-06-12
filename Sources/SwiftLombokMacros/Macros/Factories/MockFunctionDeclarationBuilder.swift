import SwiftSyntax
import SwiftSyntaxBuilder

struct MockFunctionDeclarationBuilder {
    @MemberBlockItemListBuilder
    func createCallTrackerDeclarations(_ functions: [FunctionDeclSyntax]) -> MemberBlockItemListSyntax {
        for function in functions {
            let parameterTypes = function.signature.parameterClause.parameters
                .map { $0.type }
                .map { type in
                    GenericParameterSyntax(name: TokenSyntax(stringLiteral: type.description))
                }
            let returnType = function.signature.returnClause?.type.description ?? "Void"

            let voidParameter = GenericParameterSyntax(name: TokenSyntax(stringLiteral: "Void"))

            let genericParameters = GenericParameterListSyntax(parameterTypes.isEmpty ? [voidParameter] : parameterTypes).map { p in
                p.description
            }.joined(separator: ", ")

            let mockTypeName = isThrowingFunction(function)
                ? "ThrowingMock"
                : "Mock"

            VariableDeclSyntax(
                modifiers: DeclModifierListSyntax([.init(name: .identifier(""))]),
                .var,
                name: PatternSyntax(stringLiteral: function.name.text + "Calls = \(mockTypeName)<(\(genericParameters)), \(returnType)>()")
            )
        }
    }

    @MemberBlockItemListBuilder
    func createMockImplementations(for functions: [FunctionDeclSyntax]) -> MemberBlockItemListSyntax {
        for function in functions {
            let parameterValues = function.signature.parameterClause.parameters
                .map {
                    $0.secondName?.text ?? $0.firstName.text
                }

            let tryPrefix = isThrowingFunction(function)
                ? "try "
                : ""

            FunctionDeclSyntax(
                attributes: function.attributes,
                modifiers: function.modifiers,
                funcKeyword: function.funcKeyword,
                name: function.name,
                genericParameterClause: function.genericParameterClause,
                signature: function.signature,
                genericWhereClause: function.genericWhereClause
            ) {
                CodeBlockItemSyntax(stringLiteral: tryPrefix + function.name.text + "Calls.record((\(parameterValues.joined(separator: ", "))))")
            }
        }
    }

    private func isThrowingFunction(_ function: FunctionDeclSyntax) -> Bool {
        function.signature.effectSpecifiers?.throwsSpecifier?.text == "throws"
    }
}
