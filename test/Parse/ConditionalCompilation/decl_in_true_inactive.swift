// RUN: %target-typecheck-verify-swift -D FOO -D BAR

// https://github.com/apple/swift/issues/46581
// Incorrect type checking when using defines
//
// Decls in true-but-inactive blocks used to be leaked.

func f1() -> Int {
#if FOO
  let val = 1
#elseif BAR
  let val = 2
#endif
  return val
}

func f2() -> Int {
#if FOO
#elseif BAR
  let val = 3
#endif
  return val // expected-error {{cannot find 'val' in scope}}
}

struct S1 {
#if FOO
  let val = 1
#elseif BAR
  let val = 2
#endif
  var v: Int {
    return val
  }
}

struct S2 {
#if FOO
#elseif BAR
  let val = 2
#endif
  var v: Int {
    return val // expected-error {{cannot find 'val' in scope}}
  }
}

#if FOO
let gVal1 = 1
#elseif BAR
let gVal2 = 2
#endif
_ = gVal1

#if FOO
#elseif BAR
let inactive = 3
#endif
_ = inactive // expected-error {{cannot find 'inactive' in scope}}
