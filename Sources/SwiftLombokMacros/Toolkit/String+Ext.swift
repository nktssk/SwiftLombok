public extension String {
    func toSnakeCase() -> Self {
        var snakeCaseString = ""
        for char in self {
            if char.isUppercase {
                snakeCaseString += "_" + char.lowercased()
            } else {
                snakeCaseString += String(char)
            }
        }
        return snakeCaseString
    }
    
    func toCamelCase() -> String {
        let components = self.split(separator: "_")
        guard !components.isEmpty else { return self }
    
        var camelCaseString = components.first!.lowercased()
        for component in components.dropFirst() {
            camelCaseString += component.capitalized
        }
        
        return camelCaseString
    }
}

extension String: Error {}
