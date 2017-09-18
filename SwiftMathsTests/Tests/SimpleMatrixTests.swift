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
        let rowsMatch = (m?.rowCount == rows) <?> "correct number of rows"
        let columnsMatch = (m?.columnCount == columns) <?> "correct number of columns"
        
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
        let rowsMatch = (m?.rowCount == 1) <?> "correct number of rows"
        let columnsMatch = (m?.columnCount == row.count) <?> "correct number of columns"
        
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
        let rowsMatch = (m?.rowCount == column.count) <?> "correct number of rows"
        let columnsMatch = (m?.columnCount == 1) <?> "correct number of columns"
        
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

  func testCount() {
    property("count is correct") <- forAll {
      (mat: SimpleMatrix) in
      
      return mat.count == (mat.rowCount * mat.columnCount)
    }
  }
  
  // FIXME: tests
//  func testRows() {
//    property("write tests") <- false
//  }
//
//  func testColumns() {
//    property("write tests") <- false
//  }
//
//
//  func testSubscript_get() {
//    XCTFail()
//  }
//
//  func testSubscript_set() {
//    XCTFail()
//  }

  func testTranspose() {
    property("dimensions") <- forAll {
      (mat: SimpleMatrix) in
      
      let trans = mat.transpose()
      
      let rowsMatch = (trans.rowCount == mat.columnCount) <?> "rows"
      let columnsMatch = (trans.columnCount == mat.rowCount) <?> "columns"
      
      return rowsMatch ^&&^ columnsMatch
    }
    
    property("entries") <- forAll {
      (mat: SimpleMatrix) in
      
      let trans = mat.transpose()
     
      return trans.rows.mapAnd {
        (row) in
        return trans.columns.mapAnd {
          (column) in
          return trans[row, column] == mat[column, row]
        }
      }
    }
  }

  func testRow() {
    property("invalid rows are rejected") <- forAll {
      (mat: SimpleMatrix, rowIdx: Int) in
      return !mat.rows.contains(rowIdx) ==> {
        return mat.row(rowIdx) == nil
      }
    }

    property("dimensions") <- forAll {
      (mat: SimpleMatrix) in
      return forAll(mat.rowIdxGen) {
        (rowIdx: Int) in
        guard let row = mat.row(rowIdx) else {
          return false
        }
        
        let rowsMatch = (row.rowCount == 1) <?> "rows"
        let columnsMatch = (row.columnCount == mat.columnCount) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("contents") <- forAll {
      (mat: SimpleMatrix) in
      return forAll(mat.rowIdxGen) {
        (rowIdx: Int) in
        guard let row = mat.row(rowIdx) else {
          return false
        }
        
        return row.columns.mapAnd {
          (idx) in
          return row[0, idx] == mat[rowIdx, idx]
        }
      }
    }
  }
  
  func testColumn() {
    property("invalid columns are rejected") <- forAll {
      (mat: SimpleMatrix, columnIdx: Int) in
      return !mat.columns.contains(columnIdx) ==> {
        return mat.column(columnIdx) == nil
      }
    }
    
    property("dimensions") <- forAll {
      (mat: SimpleMatrix) in
      return forAll(mat.columnIdxGen) {
        (columnIdx: Int) in
        guard let column = mat.column(columnIdx) else {
          return false
        }
        
        let rowsMatch = (column.rowCount == mat.rowCount) <?> "rows"
        let columnsMatch = (column.columnCount == 1) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("contents") <- forAll {
      (mat: SimpleMatrix) in
      return forAll(mat.columnIdxGen) {
        (columnIdx: Int) in
        guard let column = mat.column(columnIdx) else {
          return false
        }
        
        return column.rows.mapAnd {
          (idx) in
          return column[idx, 0] == mat[idx, columnIdx]
        }
      }
    }
  }

  // FIXME: tests
//  func testArrayFromRow() {
//    property("invalid rows are rejected") <- false
//
//    property("dimensions") <- false
//
//    property("contents") <- false
//  }
//
//  func testArrayFromColumn() {
//    property("invalid columns are rejected") <- false
//
//    property("dimensions") <- false
//
//    property("contents") <- false
//  }

  // FIXME: tests
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

extension SimpleMatrix: Arbitrary {
  
  enum MatrixKind: Arbitrary {
    case Empty
    case Sparse(Float)
    case Full
    
    static var arbitrary: Gen<SimpleMatrix.MatrixKind> {
      return Gen<SimpleMatrix.MatrixKind>.compose { (c) in
        switch c.generate(using: Gen<Int>.fromElements(in: 1...3)) {
        case 1:
          return .Empty
        case 2:
          return .Sparse(c.generate(using: Float.percentGen))
        case 3:
          return .Full
        default:
          assert(false)
        }
      }
    }
  }
  
  struct KindPair: Arbitrary {
    let matrix: SimpleMatrix
    let kind: MatrixKind
    
    static var arbitrary: Gen<SimpleMatrix.KindPair> {
      return Gen<SimpleMatrix.KindPair>.compose { (c) in
        let kind: MatrixKind = c.generate()
        
        let rows: Int = abs(c.generate()) + 1
        let columns: Int = abs(c.generate()) + 1
        
        var mat = SimpleMatrix(rows: rows, columns: columns)!
        
        let fillRate: Float

        switch kind {
        case .Empty: fillRate = 0
        case let .Sparse(rate): fillRate = rate
        case .Full: fillRate = 1
        }
        
        for row in 0..<rows {
          for col in 0..<columns {
            let dice = c.generate(using: Float.percentGen)
            if dice < fillRate {
              mat[row, col] = c.generate()
            }
          }
        }
        
        return KindPair(matrix: mat, kind: kind)
      }
    }
  }
  
  var rowIdxGen: Gen<Int> {
    return Gen<Int>.fromElements(of: rows)
  }
  
  var columnIdxGen: Gen<Int> {
    return Gen<Int>.fromElements(of: columns)
  }
  
  public static var arbitrary: Gen<SimpleMatrix> {
    return Gen<SimpleMatrix>.compose { (c) in
      let p: KindPair = c.generate()
      return p.matrix
    }
  }
}
