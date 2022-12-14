// RUN: %target-swift-emit-silgen -verify %s

// https://github.com/apple/swift/issues/51493

protocol SomeProtocol { }
class SomeClass: SomeProtocol { }
struct SomeStruct { var x, y: Int }

extension SomeProtocol {
    var someProperty: SomeStruct {
        nonmutating set { }
        get { return SomeStruct(x: 1, y: 2) }
    }
}

func f(i: Int) {
  SomeClass().someProperty.x = i
}


