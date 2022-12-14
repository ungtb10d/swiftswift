// RUN: %sourcekitd-test -req=index %s -- -Xfrontend -serialize-diagnostics-path -Xfrontend %t.dia %s -Xfrontend -disable-implicit-concurrency-module-import -Xfrontend -disable-implicit-string-processing-module-import | %sed_clean > %t.response
// RUN: %diff -u %s.response %t.response

public enum E {

    case one, two(a: String), three

    var text: String {
        switch self {
        case .one:
            return "one"
        case .two(let a):
            return a
        case .three:
            return "three"
        }
    }

}

let e: E = .two(a:"String")

func brokenEnums() {
  switch NonExistent.A {
  case .A:
    return "one"
  }
  switch E.one {
  case .tenthousand:
    return "one"
  }
}
