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

class SimpleMatrixTests: AbstractMatrixTests {
  
  // MARK: Required
  

  override var matrixGenerator: Gen<AnyMatrix> {
    return SimpleMatrix.arbitrary.map { return $0.wrapped }
  }

  override func matrix_init(row: [Float]) -> AnyMatrix? {
    return SimpleMatrix(row: row)?.wrapped
  }

  override func matrix_init(column: [Float]) -> AnyMatrix? {
    return SimpleMatrix(column: column)?.wrapped
  }
  
  // MARK: Init tests
  
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
  
  func testSubscript_get() {
    property("invalid indices are rejected") <- forAll {
      (matrix: SimpleMatrix, row: Int, column: Int) in
        return !(matrix.rows.contains(row) && matrix.columns.contains(column)) ==> {
          return matrix[row,column] == nil
        }
      }
    
    property("entries map correctly") <- forAll {
      (holder: SimpleMatrix.Metadata) in
      let matrix = holder.matrix
      return matrix.rows.mapAnd {
        (row) in
        return matrix.columns.mapAnd {
          (column) in
          return matrix[row,column] == holder.reference[row][column]
        }
      }
    }
  }
  
  // MARK: Subscript tests

  func testSubscript_set() {
    property("invalid indices have no effect") <- forAll {
      (matrix: SimpleMatrix, row: Int, column: Int, value: Float) in
      return !(matrix.rows.contains(row) && matrix.columns.contains(column)) ==> {
        var mutableMatrix = matrix
        mutableMatrix[row,column] = value
        return mutableMatrix == matrix
      }
    }
    
    property("setting an entry changes that entry") <- forAll {
      (matrix: SimpleMatrix, row: Int, column: Int, value: Float) in
      return (matrix.rows.contains(row) && matrix.columns.contains(column)) ==> {
        var mutableMatrix = matrix
        mutableMatrix[row,column] = value
        return mutableMatrix[row,column] == value
      }
    }
    
    property("setting an entry doesn't change other entries") <- forAll {
      (matrix: SimpleMatrix, row: Int, column: Int, value: Float) in
      return (matrix.rows.contains(row) && matrix.columns.contains(column)) ==> {
        var mutableMatrix = matrix
        mutableMatrix[row,column] = value
        return mutableMatrix.rows.mapAnd {
          (r) in
          return mutableMatrix.columns.mapAnd {
            (c) in
            if (r != row) && (c != column) {
              return mutableMatrix[r,c] == matrix[r,c]
            } else {
              return true
            }
          }
        }
      }
    }
  }
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
          return .Sparse(c.generate(using: Float.unitGen))
        case 3:
          return .Full
        default:
          assert(false)
        }
      }
    }
  }
  
  struct Metadata: Arbitrary {
    let matrix: SimpleMatrix
    let kind: MatrixKind
    let reference: [[Float]]
    
    static var arbitrary: Gen<SimpleMatrix.Metadata> {
      return Gen<SimpleMatrix.Metadata>.compose { (c) in
        let kind: MatrixKind = c.generate()
        
        let rows: Int = abs(c.generate()) + 1
        let columns: Int = abs(c.generate()) + 1
        
        var mat = SimpleMatrix(rows: rows, columns: columns)!
        var ref = [[Float]](repeating: [Float](repeating: 0, count: columns), count: rows)
        
        let fillRate: Float

        switch kind {
        case .Empty: fillRate = 0
        case let .Sparse(rate): fillRate = rate
        case .Full: fillRate = 1
        }
        
        for row in 0..<rows {
          for col in 0..<columns {
            let dice = c.generate(using: Float.unitGen)
            if dice < fillRate {
              let value: Float = c.generate()
              mat[row, col] = value
              ref[row][col] = value
            }
          }
        }
        
        return Metadata(matrix: mat, kind: kind, reference: ref)
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
      let p: Metadata = c.generate()
      return p.matrix
    }
  }
}
