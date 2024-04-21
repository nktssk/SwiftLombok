//
//  GenerateBuilderFromEnum.swift
//
//
//  Created by r.latypov on 21.04.2024.
//

import SwiftSyntax

func generateBuilderFromEnum(enumDecl: EnumDeclSyntax) throws -> StructDeclSyntax {
    let enumMember = EnumMember(
        identifier: TokenSyntax(stringLiteral: "value"),
        type: TypeSyntax(stringLiteral: enumDecl.name.text),
        value: try getFirstEnumCaseName(from: enumDecl)
    )

    return StructDeclSyntax(name: getStructBuilderName(from: enumDecl.name)) {
        MemberBlockItemListSyntax {
            MemberBlockItemSyntax(decl: makeVariableDeclWithValue(enumMember: enumMember))
            MemberBlockItemSyntax(
                leadingTrivia: .newlines(2),
                decl: makeFunctionDeclWithValue(enumMember: enumMember)
            )
        }
    }
}

func getFirstEnumCaseName(from enumDecl: EnumDeclSyntax) throws -> TokenSyntax {
    let enumCaseDecls = enumDecl.memberBlock.members.compactMap { $0.decl.as(EnumCaseDeclSyntax.self) }
    guard let firstCaseName = enumCaseDecls.first?.elements.first?.name else {
        throw "Missing enum case"
    }
    return firstCaseName
}

func makeFunctionDeclWithValue(enumMember: EnumMember) -> FunctionDeclSyntax {
    makeBuildFunctionDecl(returningType: enumMember.type) {
        ReturnStmtSyntax(expression:
            ExprSyntax(
                FunctionCallExprSyntax(
                    calledExpression: DeclReferenceExprSyntax(baseName: enumMember.identifier.trimmed),
                    arguments: LabeledExprListSyntax([])
                )
            )
        )
    }
}

func makeVariableDeclWithValue(enumMember: EnumMember) -> VariableDeclSyntax {
    VariableDeclSyntax(
        bindingSpecifier: .keyword(.var),
        bindings: PatternBindingListSyntax {
            PatternBindingSyntax(
                pattern: IdentifierPatternSyntax(identifier: enumMember.identifier),
                typeAnnotation: TypeAnnotationSyntax(type: enumMember.type),
                initializer: InitializerClauseSyntax(value: MemberAccessExprSyntax(name: enumMember.value))
            )
        }
    )
}
