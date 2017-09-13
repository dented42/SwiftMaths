//
//  SparseMatrixTests.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/12/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import SwiftCheck
import XCTest

import SwiftMaths

class SparseMatrixTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testInitWithRowsColumns() {
    XCTFail() // FIXME: write tests
  }
  
  func testSubscript() {
    XCTFail() // FIXME: write tests
  }
  
  func testTranspose() {
    XCTFail() // FIXME: write tests
  }
  
  //  func row(_: Int) -> Self?
  //  func column(_: Int) -> Self?
  
  //  func array(fromRow: Int) -> [Float]?
  //  func array(fromColumn: Int) -> [Float]?
  
  //  func subMatrix(rows: IndexSet) -> Self?
  //  func subMatrix(columns: IndexSet) -> Self?
  //  func subMatrix(rows: IndexSet, columns: IndexSet) -> Self?
  
  //  static func *(lhs: Float, rhs: Self) -> Self
  //  static func *(lhs: Self, rhs: Float) -> Self
  
  //  static func +(lhs: Self, rhs: Self) -> Self?
  //  static func -(lhs: Self, rhs: Self) -> Self?
  //  static func *(lhs: Self, rhs: Self) -> Self?
  
}

extension SparseMatrix: Arbitrary {
  public static var arbitrary: Gen<SparseMatrix> {
    <#code#>
  }
  
  
}
