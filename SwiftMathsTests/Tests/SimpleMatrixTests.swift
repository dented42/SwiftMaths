//
//  SimpleMatrixTests.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/16/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import SwiftCheck
import XCTest

import SwiftMaths

class SimpleMatrixTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  
  func testInit_RowsColumns() {
    property("invalid dimensions are rejected") <- forAll {
      (rows: Int, columns: Int) in
      return ((rows <= 0) || (columns <= 0)) ==> {
        return SimpleMatrix(rows: rows, columns: columns) == nil
      }
    }
    
    property("dimensions are correct") <- forAll {
      (rows: Int, columns: Int) in
      return ((rows > 0) && (columns > 0)) ==> {
        let m = SimpleMatrix(rows: rows, columns: columns)
        
        let exists = (m != nil) <?> "matrix exists"
        let rowsMatch = (m?.rows == rows) <?> "correct number of rows"
        let columnsMatch = (m?.columns == columns) <?> "correct number of columns"
        
        return exists ^&&^ rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries are all zero") <- forAll {
      (rows: Int, columns: Int) in
      return ((rows > 0) && (columns > 0)) ==> {
        let m = SimpleMatrix(rows: rows, columns: columns)!
        return (0..<rows).mapAnd {
          (row: Int) in
          return (0..<columns).mapAnd {
            (column: Int) in
            return (m[row, column] == 0)
          }
        }
      }
    }
  }
  
  func testInit_rowVector() {
    property("empty vector is rejected") <- {
      return SimpleMatrix(row: []) == nil
    }
    
    property("dimensions are correct") <- forAll {
      (rowHolder: ArrayOf<Float>) in
      let row = rowHolder.getArray
      return (row.count > 0) ==> {
        let m = SimpleMatrix(row: row)
        
        let exists = (m != nil) <?> "matrix exists"
        let rowsMatch = (m?.rows == 1) <?> "correct number of rows"
        let columnsMatch = (m?.columns == row.count) <?> "correct number of columns"
        
        return exists ^&&^ rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries are correct") <- forAll {
      (rowHolder: ArrayOf<Float>) in
      let row = rowHolder.getArray
      return (row.count > 0) ==> {
        guard let m = SimpleMatrix(row: row) else {
          return false
        }
        
        return row.indices.mapAnd {
          (idx: Int) in
          return m[0, idx] == row[idx]
        }
      }
    }
  }

  func testInit_columnVector() {
    property("empty vector is rejected") <- {
      return SimpleMatrix(column: []) == nil
    }
    
    property("dimensions are correct") <- forAll {
      (columnHolder: ArrayOf<Float>) in
      let column = columnHolder.getArray
      return (column.count > 0) ==> {
        let m = SimpleMatrix(column: column)
        
        let exists = (m != nil) <?> "matrix exists"
        let rowsMatch = (m?.rows == column.count) <?> "correct number of rows"
        let columnsMatch = (m?.columns == 1) <?> "correct number of columns"
        
        return exists ^&&^ rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries are correct") <- forAll {
      (columnHolder: ArrayOf<Float>) in
      let column = columnHolder.getArray
      return (column.count > 0) ==> {
        guard let m = SimpleMatrix(column: column) else {
          return false
        }
        
        return column.indices.mapAnd {
          (idx: Int) in
          return m[idx, 0] == column[idx]
        }
      }
    }
  }

//  func testCount() {
//    XCTFail()
//  }
//
//  func testSubscript_get() {
//    XCTFail()
//  }
//
//  func testSubscript_set() {
//    XCTFail()
//  }
//
//  func testTranspose() {
//    XCTFail()
//  }
//
//  func testRow() {
//    XCTFail()
//  }
//
//  func testColumn() {
//    XCTFail()
//  }
//
//  func testArrayFromRow() {
//    XCTFail()
//  }
//
//  func testArrayFromColumn() {
//    XCTFail()
//  }
//
//  func testSubMatrixRows() {
//    XCTFail()
//  }
//
//  func testSubMatrixColumns() {
//    XCTFail()
//  }
//
//  func testSubMatrixRowsColumns() {
//    XCTFail()
//  }
//
//  func testScalarMultiply() {
//    XCTFail()
//  }
//
//  func testMultiplyScalar() {
//    XCTFail()
//  }
//
//  func testAdd() {
//    XCTFail()
//  }
//
//  func testSubtract() {
//    XCTFail()
//  }
//
//  func testMultiply() {
//    XCTFail()
//  }
}

extension SimpleMatrix {
  
}
