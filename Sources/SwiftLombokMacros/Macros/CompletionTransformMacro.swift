import SwiftDiagnostics
import SwiftSyntax
import SwiftSyntaxMacros

public enum CompletionTransformMacroError: Error {
    case onlyAsyncFunctionSupported
}

public struct CompletionTransformMacro: PeerMacro {
    public static func expansion<Context: MacroExpansionContext, Declaration: DeclSyntaxProtocol>(
        of node: AttributeSyntax,
        providingPeersOf declaration: Declaration,
        in context: Context
    ) throws -> [DeclSyntax] {
        guard var funcDecl = declaration.as(FunctionDeclSyntax.self),
              funcDecl.signature.effectSpecifiers?.asyncSpecifier != nil
        else {
            throw CompletionTransformMacroError.onlyAsyncFunctionSupported
        }
        
        var resultType = funcDecl.signature.returnClause?.type
        resultType?.leadingTrivia = []
        resultType?.trailingTrivia = []
        
        let completionHandlerParam = FunctionParameterSyntax(
            firstName: .identifier("completionHandler"),
            colon: .colonToken(trailingTrivia: .space),
            type: "@escaping (\(resultType ?? "")) -> Void" as TypeSyntax
        )
        
        let parameterList = funcDecl.signature.parameterClause.parameters
        let newParameterList: FunctionParameterListSyntax
        
        if var lastParam = parameterList.last {
            lastParam.trailingComma = .commaToken(trailingTrivia: .space)
            newParameterList = parameterList.dropLast() + [lastParam, completionHandlerParam]
        } else {
            newParameterList = [completionHandlerParam]
        }
        
        let callArguments: [String] = parameterList.map { param in
            let argName = param.secondName ?? param.firstName
            
            let paramName = param.firstName
            if paramName.text != "_" {
                return "\(paramName.text): \(argName.text)"
            }
            
            return "\(argName.text)"
        }
        
        let call: ExprSyntax = "\(funcDecl.name)(\(raw: callArguments.joined(separator: ", ")))"
        let newBody: ExprSyntax = "Task { completionHandler(await \(call)) }"
        
        let newAttributeList = funcDecl.attributes.filter {
            guard case let .attribute(attribute) = $0,
                  let attributeType = attribute.attributeName.as(IdentifierTypeSyntax.self),
                  let nodeType = node.attributeName.as(IdentifierTypeSyntax.self)
            else {
                return true
            }
            
            return attributeType.name.text != nodeType.name.text
        }
        
        funcDecl.signature.effectSpecifiers?.asyncSpecifier = nil
        funcDecl.signature.returnClause = nil
        funcDecl.signature.parameterClause.parameters = newParameterList
        funcDecl.signature.parameterClause.trailingTrivia = []
        
        funcDecl.body = CodeBlockSyntax(
            leftBrace: .leftBraceToken(leadingTrivia: .space),
            statements: CodeBlockItemListSyntax(
                [CodeBlockItemSyntax(item: .expr(newBody))]
            ),
            rightBrace: .rightBraceToken(leadingTrivia: .newline)
        )
        
        funcDecl.attributes = newAttributeList
        funcDecl.leadingTrivia = .newlines(2)
        
        return [DeclSyntax(funcDecl)]
    }
}
