public struct Mock<ArgumentType, ReturnType> {
    public typealias CallType = ((ArgumentType) -> ReturnType)

    private var callMock: CallType

    // MARK: - Init
    public init(
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        self.init { _ in
            preconditionFailure("Default value or default behaviour expected!")
        }
    }

    public init(defaultReturnValue: ReturnType) {
        callMock = { _ in defaultReturnValue }
    }

    public init(mock: @escaping CallType) {
        self.callMock = mock
    }

    public var latestCall: ArgumentType? {
        callsHistory.last
    }

    public var callsCount: Int {
        callsHistory.count
    }

    public var hasBeenCalled: Bool {
        callsCount > 0
    }

    public mutating func mockCall(_ mock: @escaping CallType) {
        callMock = mock
    }

    public private(set) var callsHistory: [ArgumentType] = []

    public mutating func record(_ arguments: ArgumentType) -> ReturnType {
        callsHistory.append(arguments)
        return callMock(arguments)
    }
}

public extension Mock where ReturnType == Void {
    init() {
        self.init { _ in }
    }
}

public extension Mock where ArgumentType == Void {
    mutating func record() -> ReturnType {
        self.record(())
    }
}

public struct MockVariable<VarType> {
    public var setter: Mock<VarType, Void>
    public var getter: Mock<Void, VarType>

    public init() {
        self.setter = .init()
        self.getter = .init()
    }
}

public struct ThrowingMock<ArgumentType, ReturnType> {
    public typealias CallType = ((ArgumentType) throws -> ReturnType)

    private var callMock: CallType

    public init(
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        self.init { _ in
            preconditionFailure("Default value or default behaviour expected!")
        }
    }

    public init(defaultReturnValue: ReturnType) {
        callMock = { _ in defaultReturnValue }
    }

    public init(mock: @escaping CallType) {
        self.callMock = mock
    }

    public var latestCall: ArgumentType? {
        callsHistory.last
    }

    public var callsCount: Int {
        callsHistory.count
    }

    public var hasBeenCalled: Bool {
        callsCount > 0
    }

    public mutating func mockCall(_ mock: @escaping CallType) {
        callMock = mock
    }

    public private(set) var callsHistory: [ArgumentType] = []

    public mutating func record(_ arguments: ArgumentType) throws -> ReturnType {
        callsHistory.append(arguments)
        return try callMock(arguments)
    }
}