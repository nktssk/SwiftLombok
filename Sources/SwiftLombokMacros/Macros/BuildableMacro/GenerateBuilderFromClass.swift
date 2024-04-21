//
//  GenerateBuilderFromClass.swift
//
//
//  Created by r.latypov on 21.04.2024.
//

import SwiftSyntax

func generateBuilderFromClass(classDecl: ClassDeclSyntax) throws -> StructDeclSyntax {
    guard let initialiserDecl = getFirstInitialiser(from: classDecl.memberBlock) else {
        throw "Missing initialiser"
    }
    let structMembers = extractInitializerMembers(from: initialiserDecl)

    return makeStructBuilder(withStructName: classDecl.name, and: structMembers)
}

func generateBuilderFromStruct(structDecl: StructDeclSyntax) -> StructDeclSyntax {
    let structMembers = getStructMembers(structDecl: structDecl)
    return makeStructBuilder(withStructName: structDecl.name, and: structMembers)
}

private func getStructMembers(structDecl: StructDeclSyntax) -> [StructMember] {
    if let initialiserDecl = getFirstInitialiser(from: structDecl.memberBlock) {
        return extractInitializerMembers(from: initialiserDecl)
    } else {
        return extractMembersFrom(structDecl.memberBlock.members)
    }
}

func extractInitializerMembers(from initialiserDecl: InitializerDeclSyntax) -> [StructMember] {
    initialiserDecl.signature.parameterClause.parameters.compactMap {
        guard let functionParameter = $0.as(FunctionParameterSyntax.self) else { return nil }
        let identifier = functionParameter.firstName.trimmed
        let type = functionParameter.type
        return StructMember(identifier: identifier, type: type)
    }
}

func getFirstInitialiser(from memberBlock: MemberBlockSyntax) -> InitializerDeclSyntax? {
    memberBlock.members
        .compactMap { $0.decl.as(InitializerDeclSyntax.self) }
        .first
}

func makeFunctionDecl(name: TokenSyntax, structMembers: [StructMember]) -> FunctionDeclSyntax {
    makeBuildFunctionDecl(returningType: TypeSyntax(stringLiteral: name.text)) {
        ReturnStmtSyntax(expression:
            ExprSyntax(
                makeFunctionCallExpr(name: name, structMembers: structMembers)
            )
        )
    }
}

private func makeFunctionCallExpr(name: TokenSyntax, structMembers: [StructMember]) -> FunctionCallExprSyntax{
    FunctionCallExprSyntax(
        calledExpression: DeclReferenceExprSyntax(baseName: name.trimmed),
        leftParen: .leftParenToken(trailingTrivia: Trivia.spaces(4)),
        arguments: makeLabeledExprList(structMembers: structMembers),
        rightParen: .rightParenToken(leadingTrivia: .newline)
    )
}

private func makeLabeledExprList(structMembers: [StructMember]) -> LabeledExprListSyntax {
    LabeledExprListSyntax {
        for structMember in structMembers {
            LabeledExprSyntax(
                leadingTrivia: .newline,
                label: structMember.identifier,
                colon: TokenSyntax(TokenKind.colon, presence: .present),
                expression: ExprSyntax(stringLiteral: structMember.identifier.text)
            )
        }
    }
}
