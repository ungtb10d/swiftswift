// RUN: %target-swift-frontend -typecheck %s

// rdar://problem/32618740
// https://github.com/apple/swift/issues/47696

protocol InitCollection: Collection {
  init(_ array: [Iterator.Element])
}

protocol InitAny {
  init()
}

extension Array: InitCollection {
  init(_ array: [Iterator.Element]) {
    self = array
  }
}

extension String: InitAny {
  init() {
    self = "bar"
  }
}

class Foo {
  func foo<T: InitCollection, U: InitAny>(of type: U.Type) -> T
  where T.Iterator.Element == U
  {
    return T.init([U.init()])
  }

  func foo<T: InitCollection, U: InitAny>(of type: U.Type) -> T?
  where T.Iterator.Element == U
  {
    return T.init([U.init()])
  }
}

let _: [String] = Foo().foo(of: String.self)
