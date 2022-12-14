// RUN: %target-run-stdlib-swift
// REQUIRES: executable_test,optimized_stdlib
// UNSUPPORTED: freestanding

// Some targeted tests for the breadcrumbs path. There is some overlap with
// UTF16View tests for huge strings, but we want a simpler suite that targets
// some corner cases specifically.

import Swift
import StdlibUnittest

let smallASCII = "abcdefg"
let smallUnicode = "abรฉร๐"
let largeASCII = "012345678901234567890"
let largeUnicode = "abรฉร012345678901234567890๐"
let emoji = "๐๐๐คข๐คฎ๐ฉ๐ฟโ๐ค๐ง๐ปโโ๏ธ๐ง๐ปโโ๏ธ๐ฉโ๐ฉโ๐ฆโ๐ฆ"
let chinese = "Swift ๆฏ้ขๅ Apple ๅนณๅฐ็็ผ็จ่ฏญ่จ๏ผๅ่ฝๅผบๅคงไธ็ด่งๆ็จ๏ผ่ๆฌๆฌกๆดๆฐๅฏนๅถ่ฟ่กไบๅจ้ขไผๅใ"

let nonBMP = String(repeating: "๐", count: 1 + (64 / 2))

let largeString: String = {
  var result = ""
  result += smallASCII
  result += smallUnicode
  result += largeASCII
  result += chinese
  result += largeUnicode
  result += emoji
  result += smallASCII
  result += result.reversed()
  return result
}()

extension FixedWidthInteger {
  var hexStr: String { return "0x\(String(self, radix: 16, uppercase: true))" }
}

let StringBreadcrumbsTests = TestSuite("StringBreadcrumbsTests")

func validateBreadcrumbs(_ str: String) {
  var utf16CodeUnits = Array(str.utf16)
  var outputBuffer = Array<UInt16>(repeating: 0, count: utf16CodeUnits.count)

  // Include the endIndex, so we can test end conversions
  var utf16Indices = Array(str.utf16.indices) + [str.utf16.endIndex]

  for i in 0...utf16CodeUnits.count {
    for j in i...utf16CodeUnits.count {
      let range = Range(uncheckedBounds: (i, j))

      let indexRange = str._toUTF16Indices(range)

      // Range<String.Index> <=> Range<Int>
      expectEqual(utf16Indices[i], indexRange.lowerBound)
      expectEqual(utf16Indices[j], indexRange.upperBound)
      expectEqualSequence(
        utf16CodeUnits[i..<j], str.utf16[indexRange])
      let roundTripOffsets = str._toUTF16Offsets(indexRange)
      expectEqualSequence(range, roundTripOffsets)

      // Single Int <=> String.Index
      expectEqual(indexRange.lowerBound, str._toUTF16Index(i))
      expectEqual(indexRange.upperBound, str._toUTF16Index(j))
      expectEqual(i, str._toUTF16Offset(indexRange.lowerBound))
      expectEqual(j, str._toUTF16Offset(indexRange.upperBound))

      // Copy characters
      outputBuffer.withUnsafeMutableBufferPointer {
        str._copyUTF16CodeUnits(into: $0, range: range)
      }
      expectEqualSequence(utf16CodeUnits[i..<j], outputBuffer[..<range.count])
    }
  }
}

StringBreadcrumbsTests.test("uniform strings") {
  validateBreadcrumbs(smallASCII)
  validateBreadcrumbs(largeASCII)
  validateBreadcrumbs(smallUnicode)
  validateBreadcrumbs(largeUnicode)
}

StringBreadcrumbsTests.test("largeString") {
  validateBreadcrumbs(largeString)
}

// Test various boundary conditions with surrogate pairs aligning or not
// aligning
StringBreadcrumbsTests.test("surrogates-heavy") {

  // Mis-align the hieroglyphics by 1,2,3 UTF-8 and UTF-16 code units
  validateBreadcrumbs(nonBMP)
  validateBreadcrumbs("a" + nonBMP)
  validateBreadcrumbs("ab" + nonBMP)
  validateBreadcrumbs("abc" + nonBMP)
  validateBreadcrumbs("รฉ" + nonBMP)
  validateBreadcrumbs("ๆฏ" + nonBMP)
  validateBreadcrumbs("aรฉ" + nonBMP)
}

// Test bread-crumb invalidation
StringBreadcrumbsTests.test("stale breadcrumbs") {
  var str = nonBMP + "๐"
  let oldLen = str.utf16.count
  str.removeLast()
  expectEqual(oldLen - 2, str.utf16.count)
  str += "a"
  expectEqual(oldLen - 1, str.utf16.count)
  str += "๐"
  expectEqual(oldLen + 1, str.utf16.count)
}



runAllTests()
