// RUN: %target-typecheck-verify-swift -enable-experimental-string-processing
// REQUIRES: libswift

var s = 'abc'

var s1 = ('*', '+', '?')
// expected-error@-1 3{{cannot start regex with quantifier}}

var s2 = '\w+'
var s3 = '\'\\'