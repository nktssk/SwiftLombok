import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct SpecConstantMacro: DeclarationMacro {
    public static func expansion(
        of node: some FreestandingMacroExpansionSyntax,
        in context: some MacroExpansionContext
    ) -> [DeclSyntax] {
        guard node.argumentList.count == 2 else {
            fatalError("compiler bug: the macro does not have the necessary arguments")
        }
        let firstIndex = node.argumentList.startIndex
        let secondIndex = node.argumentList.index(after: firstIndex)
        
        let rawName = node.argumentList[firstIndex].expression.as(StringLiteralExprSyntax.self)!.rawValue
        let value = node.argumentList[secondIndex].expression

        return [
            DeclSyntax("static let \(raw: rawName): CGFloat = \(value)")
        ]
    }
}
