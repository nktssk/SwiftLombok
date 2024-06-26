import SwiftSyntaxMacros
import SwiftSyntaxBuilder
import SwiftSyntax

extension LabeledExprListSyntax {
    mutating func appendAndFixTrailingComma(expression: LabeledExprSyntax) {
        if let lastIndex = indices.last {
            let trailingTrivia = self[lastIndex].trailingComma?.trailingTrivia ?? .space
            self[lastIndex].trailingComma = .commaToken(trailingTrivia: trailingTrivia)
        }

        append(expression)
    }

    mutating func addOrUpdateArgument(
        label: String,
        expression: some ExprSyntaxProtocol,
        allArguments: LabeledExprListSyntax
    ) {
        let label = TokenSyntax.identifier(label)

        var argumentExpression = LabeledExprSyntax(
            label: label,
            colon: .colonToken(trailingTrivia: .space),
            expression: expression
        )

        guard !isEmpty else {
            insert(
                argumentExpression,
                at: startIndex
            )
            return
        }

        if let existingArgumentIndex = firstIndex(where: { $0.label?.text == label.text }) {
            self[existingArgumentIndex].expression = ExprSyntax(expression)
        } else if let indexInAllArguments = allArguments.firstIndex(where: { $0.label?.text == label.text }) {
            let possibleIndicesInAllArguments = allArguments.indices.prefix(while: { $0 != indexInAllArguments })
            for priorIndex in possibleIndicesInAllArguments.reversed() {
                let defaultArgument = allArguments[priorIndex]

                if let indexBeforeIndexToInsertAt = firstIndex(where: { $0.label?.text == defaultArgument.label?.text }) {
                    let indexToInsertAt = index(after: indexBeforeIndexToInsertAt)
                    if indexToInsertAt != endIndex {
                        argumentExpression.trailingComma = .commaToken(trailingTrivia: .space)
                    } else {
                        self[indexBeforeIndexToInsertAt].trailingComma  = .commaToken(trailingTrivia: .space)
                    }
                    insert(
                        argumentExpression,
                        at: indexToInsertAt
                    )
                    return
                }
            }
            
            argumentExpression.trailingComma = .commaToken(trailingTrivia: .space)
            insert(
                argumentExpression,
                at: startIndex
            )
        } else {
            appendAndFixTrailingComma(
                expression: argumentExpression
            )
        }
    }
}

extension LabeledExprListSyntax {
    static var allHashableArguments: LabeledExprListSyntax {
        [
            LabeledExprSyntax(
                label: "finalHashInto",
                expression: BooleanLiteralExprSyntax(booleanLiteral: true)
            ),
            LabeledExprSyntax(
                label: "isEqualToTypeFunctionName",
                expression: MemberAccessExprSyntax(
                    declName: DeclReferenceExprSyntax(
                        baseName: .identifier("automatic")
                    )
                )
            ),
            LabeledExprSyntax(
                label: "allowEmptyImplementation",
                expression: BooleanLiteralExprSyntax(booleanLiteral: false)
            ),
            LabeledExprSyntax(
                label: "_disableNSObjectSubclassSupport",
                expression: BooleanLiteralExprSyntax(booleanLiteral: false)
            ),
        ]
    }
    mutating func addOrUpdateHashableArgument(
        label: String,
        expression: some ExprSyntaxProtocol
    ) {
        addOrUpdateArgument(label: label, expression: expression, allArguments: .allHashableArguments)
    }
}
