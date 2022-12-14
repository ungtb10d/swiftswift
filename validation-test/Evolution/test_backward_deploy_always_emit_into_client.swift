// RUN: %target-resilience-test --backward-deployment
// REQUIRES: executable_test

// https://github.com/apple/swift/issues/53303
// UNSUPPORTED: OS=windows-msvc

import StdlibUnittest
import backward_deploy_always_emit_into_client


var BackwardDeployTopLevelTest = TestSuite("BackwardDeployAlwaysEmitIntoClient")

BackwardDeployTopLevelTest.test("BackwardDeployAlwaysEmitIntoClient") {
  expectEqual(serializedFunction(), getVersion() == 1 ? "new" : "old")
}

runAllTests()
