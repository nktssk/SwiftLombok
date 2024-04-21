//
//  DeclSyntax.swift
//
//
//  Created by r.latypov on 21.04.2024.
//

import SwiftSyntax

func makeStructBuilder(withStructName structName: TokenSyntax, and structMembers: [StructMember]) -> StructDeclSyntax {
    StructDeclSyntax(name: getStructBuilderName(from: structName)) {
        MemberBlockItemListSyntax {
            for structMember in structMembers {
                MemberBlockItemSyntax(decl: makeVariableDecl(structMember: structMember))
            }
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDecl(name: structName, structMembers: structMembers)
            )
        }
    }
}

func makeVariableDecl(structMember: StructMember) -> VariableDeclSyntax {
    VariableDeclSyntax(
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: structMember.identifier),
                typeAnnotation: TypeAnnotationSyntax(type: structMember.type),
                initializer: getDefaultInitializerClause(type: structMember.type)
            )
        }
    )
}

func makeBuildFunctionDecl(returningType: TypeSyntax, body: () -> ReturnStmtSyntax) -> FunctionDeclSyntax {
    let buildFunctionSignature = FunctionSignatureSyntax(
        parameterClause: FunctionParameterClauseSyntax(parameters: FunctionParameterListSyntax([])),
        returnClause: ReturnClauseSyntax(type: returningType)
    )

    return FunctionDeclSyntax(name: .identifier("build"), signature: buildFunctionSignature) {
        CodeBlockItemListSyntax {
            CodeBlockItemSyntax(
                item: CodeBlockItemListSyntax.Element.Item.stmt(StmtSyntax(body()))
            )
        }
    }
}

func getStructBuilderName(from name: TokenSyntax) -> TokenSyntax {
    TokenSyntax.identifier(name.text + "Builder")
        .with(\.trailingTrivia, .spaces(1))
}

private func getDefaultInitializerClause(type: TypeSyntax) -> InitializerClauseSyntax? {
    guard let defaultExpr = getDefaultValueForType(type) else { return nil }
    return InitializerClauseSyntax(value: defaultExpr)
}

func getDefaultValueForType(_ type: TypeSyntax) -> ExprSyntax? {
    if type.kind == .optionalType {
        return nil
    } else if type.kind == .implicitlyUnwrappedOptionalType {
        return nil
    } else if type.kind == .dictionaryType {
        return ExprSyntax(stringLiteral: "[:]")
    } else if type.kind == .arrayType {
        return ExprSyntax(stringLiteral: "[]")
    } else if let defaultValue = mapping[type.trimmedDescription] {
        return defaultValue
    } else {
        return ExprSyntax(stringLiteral: type.trimmedDescription + "Builder().build()")
    }
}

private var mapping: [String: ExprSyntax] = [
    "String": "\"\"",
    "Int": "0",
    "Int8": "0",
    "Int16": "0",
    "Int32": "0",
    "Int64": "0",
    "UInt": "0",
    "UInt8": "0",
    "UInt16": "0",
    "UInt32": "0",
    "UInt64": "0",
    "Bool": "false",
    "Double": "0",
    "Float": "0",
    "Date": "Date()",
    "UUID": "UUID()",
    "Data": "Data()",
    "URL": "URL(string: \"https://www.google.com\")!",
    "CGFloat": "0",
    "CGPoint": "CGPoint()",
    "CGRect": "CGRect()",
    "CGSize": "CGSize()",
    "CGVector": "CGVector()",
]
