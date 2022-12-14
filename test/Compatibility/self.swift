// RUN: %target-typecheck-verify-swift -swift-version 4

// https://github.com/apple/swift/issues/43310
// In version 4 and earlier all of these should build with no diagnostic.
class Mario {
    func getFriend() -> Self { return self }
    func getEnemy() -> Mario { return self }
}
class SuperMario : Mario {
    override func getFriend() -> SuperMario {
        return SuperMario()
    }
    override func getEnemy() -> Self { return self }
}
final class FinalMario : Mario {
    override func getFriend() -> FinalMario {
        return FinalMario()
    }
}
