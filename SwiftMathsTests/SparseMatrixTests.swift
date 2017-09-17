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
  
  func testInit_RowsColumns() {
    XCTFail()
  }
  
  func testInit_rowVector() {
    XCTFail()
  }
  
  func testInit_columnVector() {
    XCTFail()
  }
  
  func testSubscript() {
    XCTFail()
  }
  
  func testTranspose() {
    XCTFail()
  }
  
  func testRow() {
    XCTFail()
  }
  
  func testColumn() {
    XCTFail()
  }
  
  func testArrayFromRow() {
    XCTFail()
  }
  
  func testArrayFromColumn() {
    XCTFail()
  }
  
  func testSubMatrixRows() {
    XCTFail()
  }
  
  func testSubMatrixColumns() {
    XCTFail()
  }
  
  func testSubMatrixRowsColumns() {
    XCTFail()
  }
  
  func testScalarMultiply() {
    XCTFail()
  }
  
  func testMultiplyScalar() {
    XCTFail()
  }
  
  func testAdd() {
    XCTFail()
  }
  
  func testSubtract() {
    XCTFail()
  }
  
  func testMultiply() {
    XCTFail()
  }
}

extension SparseMatrix/*: Arbitrary*/ {
  public static var zerosGen: Gen<SparseMatrix> {
    return Gen<(Int,Int)>.zip(Int.naturalsGen, Int.naturalsGen).map { (pair: (Int,Int)) in
      let (r,c) = pair
      return SparseMatrix(rows: r, columns: c)
    }
  }
  
//  public static var arbitrary: Gen<SparseMatrix> {
//
//  }

}

