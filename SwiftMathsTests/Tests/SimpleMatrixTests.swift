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
    property("write tests") <- false
  }

  func testSubscript_set() {
    property("write tests") <- false
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
