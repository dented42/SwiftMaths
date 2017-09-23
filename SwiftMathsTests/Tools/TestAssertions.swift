//
//  TestAssertions.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/18/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation
import XCTest

extension XCTestCase {
  
  
  /// Assert that the class in which the test is defined is meant to be an abstract test case that
  /// other test cases inherit from.
  ///
  /// It operates by firing an assertion failure when run by a class that matches the provided name.
  /// The failure message instructs that the abstract class not be included in the suite of test cases
  /// to be run.
  ///
  /// - Parameters:
  ///   - name: The fully qualified name of the abstract class.
  ///   - file: The file in which the assertion is called.
  ///   - line: The line of code in which the assertion is called.
  func AssertAbstractTestClass(name: String,
                               file: StaticString = #file, line: UInt = #line) {
    // if our class name matches then complain.
    if name == self.className {
      let message = "\(name) is an abstract test case and should not be directly included in this suite of tests."
      XCTFail(message, file: file, line: line)
    }
  }
}
