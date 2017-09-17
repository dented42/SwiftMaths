//
//  FunctionalTests.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/17/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import SwiftCheck
import XCTest

import SwiftMaths

class FunctionalTests: XCTestCase {

  func testIdentity() {
    property("always returns its argument") <- forAll {
      (s: String) in
      return identity(s) == s
    }
  }
  
  func testConstant() {
    property("always returns its argument") <- forAll {
      (s: String) in
      let constS: (Int) -> String = constant(s)
      return forAll {
        (n: Int) in
        return constS(n) == s
      }
    }
  }

}
