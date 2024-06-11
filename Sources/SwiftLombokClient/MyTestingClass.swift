func testingMock() {
    let myClass = MyTestingClass()
    myClass.mock.priority.getter.mockCall { 1 }
    print(myClass.priority) // prints `1`
    myClass.doSomething()
    print(myClass.mock.doSomethingCalls.callsCount == 1) // prints `true`
    myClass.mock.performCalls.mockCall { param in
        "mocked => \(param)"
    }
    print(myClass.perform(with: 1))
}