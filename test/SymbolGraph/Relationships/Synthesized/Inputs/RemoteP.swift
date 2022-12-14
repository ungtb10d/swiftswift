/// Some Protocol
public protocol P {
    func someFunc()

    /// This one has docs!
    func otherFunc()

    func bonusFunc()
}

public extension P {
    /// Extra default docs!
    func extraFunc() {}
}

public struct PImpl: P {
    public func someFunc() {}

    public func otherFunc() {}

    public func bonusFunc() {}
}

public struct NoPImpl {}
