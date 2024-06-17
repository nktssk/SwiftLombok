import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

public struct LocalizableMacro: MemberMacro {

    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        guard let enumDecl = declaration.memberBlock.members.compactMap(asEnumDecl).first else {
            context.diagnose(LocalizableMacroDiagnostic.requiresEnum.diagnose(at: declaration))
            return []
        }
        let enumCases = enumDecl.memberBlock.members.flatMap(asEnumCaseDecl)
        let enumMembers = enumCases.map(casesToEnumMembers)
        return enumMembers
    }

    private static func asEnumDecl(_ member: MemberBlockItemSyntax) -> EnumDeclSyntax? {
        member.decl.as(EnumDeclSyntax.self)
    }
    
    private static func asEnumCaseDecl(_ member: MemberBlockItemSyntax) -> [EnumCaseElementSyntax] {
        guard let caseDecl = member.decl.as(EnumCaseDeclSyntax.self) else {
            return [EnumCaseElementSyntax]()
        }
        return Array(caseDecl.elements)
    }
    
    private static func casesToEnumMembers(_ element: EnumCaseElementSyntax) -> DeclSyntax {
        if element.parameterClause != nil {
            return makeStaticFunc(from: element)
        }
        return makeStaticField(from: element)
    }

    private static func makeStaticField(from element: EnumCaseElementSyntax) -> DeclSyntax {
        """
        static let \(element.name) = NSLocalizedString("\(element.name)", comment: "")
        """
    }
    
    private static func makeStaticFunc(from element: EnumCaseElementSyntax) -> DeclSyntax {
        let parameterList = element.parameterClause?.parameters ?? []
        let syntax = """
        static func \(element.name)(\(makeFuncParameters(from: parameterList))) -> String {
            String(format: NSLocalizedString("\(element.name)", comment: ""),\(makeFuncArguments(from: parameterList)))
        }
        """
        return DeclSyntax(stringLiteral: syntax)
    }

    private static func makeFuncParameters(from list: EnumCaseParameterListSyntax) -> String {
        list
            .enumerated()
            .map { "_ value\($0): \($1.type.as(IdentifierTypeSyntax.self)!.name.text)" }
            .joined(separator: ",")
    }
    
    private static func makeFuncArguments(from list: EnumCaseParameterListSyntax) -> String {
        list
            .enumerated()
            .map { " value\($0.offset)" }
            .joined(separator: ",")
    }
}
