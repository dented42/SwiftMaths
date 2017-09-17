//
//  SequenceTests.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/17/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import SwiftCheck
import XCTest

class SequenceTests: XCTestCase {

  func testMapAnd() {
    property("empty sequence maps true") <- false
    
    property("write tests") <- false
  }
  
  func testMapOr() {
    property("empty sequence maps false") <- false
    
    property("write tests") <- false
  }

}
