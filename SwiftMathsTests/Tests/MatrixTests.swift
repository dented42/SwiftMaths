//
//  MatrixTests.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/17/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import SwiftCheck
import XCTest

import SwiftMaths

class MatrixTests: XCTestCase {
  
  // Mark: Default methods
  
  func testInit_row() {
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
  
  func testInit_column() {
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
  
  func testRows() {
    property("correct lower bound") <- forAll {
      (mat: SimpleMatrix) in
      return mat.rows.first == 0
    }
    
    property("correct upper bound") <- forAll {
      (mat: SimpleMatrix) in
      return mat.rows.last == (mat.rowCount - 1)
    }
  }
  
  func testColumns() {
    property("correct lower bound") <- forAll {
      (mat: SimpleMatrix) in
      return mat.columns.first == 0
    }
    
    property("correct upper bound") <- forAll {
      (mat: SimpleMatrix) in
      return mat.columns.last == (mat.columnCount - 1)
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
  
  func testArrayFromRow() {
    property("invalid rows are rejected") <- forAll {
      (mat: SimpleMatrix, rowIdx: Int) in
      return !mat.rows.contains(rowIdx) ==> {
        return mat.array(fromRow: rowIdx) == nil
      }
    }
    
    property("dimensions") <- forAll {
      (mat: SimpleMatrix) in
      return forAll(mat.rowIdxGen) {
        (rowIdx: Int) in
        guard let row = mat.array(fromRow: rowIdx) else {
          return false
        }
        
        return row.count == mat.columnCount
      }
    }
    
    property("contents") <- forAll {
      (mat: SimpleMatrix) in
      return forAll(mat.rowIdxGen) {
        (rowIdx: Int) in
        guard let row = mat.array(fromRow: rowIdx) else {
          return false
        }
        
        return row.indices.mapAnd {
          (idx) in
          return row[idx] == mat[rowIdx, idx]
        }
      }
    }
  }
  
  func testArrayFromColumn() {
    property("invalid columns are rejected") <- forAll {
      (mat: SimpleMatrix, columnIdx: Int) in
      return !mat.columns.contains(columnIdx) ==> {
        return mat.array(fromColumn: columnIdx) == nil
      }
    }
    
    property("dimensions") <- forAll {
      (mat: SimpleMatrix) in
      return forAll(mat.columnIdxGen) {
        (columnIdx: Int) in
        guard let column = mat.array(fromColumn: columnIdx) else {
          return false
        }
        
        return column.count == mat.rowCount
      }
    }
    
    property("contents") <- forAll {
      (mat: SimpleMatrix) in
      return forAll(mat.columnIdxGen) {
        (columnIdx: Int) in
        guard let column = mat.array(fromColumn: columnIdx) else {
          return false
        }
        
        return column.indices.mapAnd {
          (idx) in
          return column[idx] == mat[idx, columnIdx]
        }
      }
    }
  }
  
  func testSubMatrixRows() {
    property("write tests") <- false
  }
  
  func testSubMatrixColumns() {
    property("write tests") <- false
  }
  
  func testSubMatrixRowsColumns() {
    property("write tests") <- false
  }
  
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
    
    property("transpose^2 = id") <- forAll {
      (matrix: SimpleMatrix) in
      return matrix.transpose().transpose() == matrix
    }
  }
  
  func testScalarMultiply() {
    property("dimensions") <- forAll {
      (matrix: SimpleMatrix, scalar: Float) in
      let scaled = scalar * matrix
      
      let rowsMatch = (scaled.rowCount == matrix.rowCount) <?> "rows"
      let columnsMatch = (scaled.columnCount == matrix.columnCount) <?> "columns"
      
      return rowsMatch ^&&^ columnsMatch
    }
    
    property("entries") <- forAll {
      (matrix: SimpleMatrix, scalar: Float) in
      let scaled = scalar * matrix
      
      return scaled.rows.mapAnd {
        (row) in
        return scaled.columns.mapAnd {
          (column) in
          return scaled[row,column] == (matrix[row,column]! * scalar)
        }
      }
    }
  }
  
  func testMultiplyScalar() {
    property("dimensions") <- forAll {
      (matrix: SimpleMatrix, scalar: Float) in
      let scaled =  matrix * scalar
      
      let rowsMatch = (scaled.rowCount == matrix.rowCount) <?> "rows"
      let columnsMatch = (scaled.columnCount == matrix.columnCount) <?> "columns"
      
      return rowsMatch ^&&^ columnsMatch
    }
    
    property("entries") <- forAll {
      (matrix: SimpleMatrix, scalar: Float) in
      let scaled =  matrix * scalar
      
      return scaled.rows.mapAnd {
        (row) in
        return scaled.columns.mapAnd {
          (column) in
          return scaled[row,column] == (matrix[row,column]! * scalar)
        }
      }
    }
  }
  
  func testAdd() {
    property("invalid dimensions fail") <- forAll {
      (mat1: SimpleMatrix, mat2: SimpleMatrix) in
      return ((mat1.rowCount != mat2.rowCount) && (mat1.columnCount != mat2.columnCount)) ==> {
        return (mat1 + mat2) == nil
      }
    }
    
    property("dimensions") <- forAll {
      (mat1: SimpleMatrix, mat2: SimpleMatrix) in
      return ((mat1.rowCount == mat2.rowCount) && (mat1.columnCount == mat2.columnCount)) ==> {
        guard let mat3 = mat1 + mat2 else {
          return false
        }
        
        let rowsMatch = (mat3.rowCount == mat1.rowCount) <?> "rows"
        let columnsMatch = (mat3.columnCount == mat1.columnCount) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries") <- forAll {
      (mat1: SimpleMatrix, mat2: SimpleMatrix) in
      return ((mat1.rowCount == mat2.rowCount) && (mat1.columnCount == mat2.columnCount)) ==> {
        guard let mat3 = mat1 + mat2 else {
          return false
        }
        
        return mat3.rows.mapAnd {
          (row) in
          return mat3.columns.mapAnd {
            (column) in
            return mat3[row,column] == (mat1[row,column]! + mat2[row,column]!)
          }
        }
      }
    }
  }
  
  func testSubtract() {
    property("invalid dimensions fail") <- forAll {
      (mat1: SimpleMatrix, mat2: SimpleMatrix) in
      return ((mat1.rowCount != mat2.rowCount) && (mat1.columnCount != mat2.columnCount)) ==> {
        return (mat1 - mat2) == nil
      }
    }
    
    property("dimensions") <- forAll {
      (mat1: SimpleMatrix, mat2: SimpleMatrix) in
      return ((mat1.rowCount == mat2.rowCount) && (mat1.columnCount == mat2.columnCount)) ==> {
        guard let mat3 = mat1 - mat2 else {
          return false
        }
        
        let rowsMatch = (mat3.rowCount == mat1.rowCount) <?> "rows"
        let columnsMatch = (mat3.columnCount == mat1.columnCount) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries") <- forAll {
      (mat1: SimpleMatrix, mat2: SimpleMatrix) in
      return ((mat1.rowCount == mat2.rowCount) && (mat1.columnCount == mat2.columnCount)) ==> {
        guard let mat3 = mat1 - mat2 else {
          return false
        }
        
        return mat3.rows.mapAnd {
          (row) in
          return mat3.columns.mapAnd {
            (column) in
            return mat3[row,column] == (mat1[row,column]! - mat2[row,column]!)
          }
        }
      }
    }
  }
  
  func testMultiply() {
    property("invalid dimensions fail") <- forAll {
      (matrix1: SimpleMatrix, matrix2: SimpleMatrix) in
      return (matrix1.columnCount != matrix2.rowCount) ==> {
        return (matrix1 * matrix2) == nil
      }
    }
    
    property("dimensions") <- forAll {
      (matrix1: SimpleMatrix, matrix2: SimpleMatrix) in
      return (matrix1.columnCount == matrix2.rowCount) ==> {
        guard let product = matrix1 * matrix2 else {
          return false
        }
        
        let rowsMatch = (product.rowCount == matrix1.rowCount) <?> "rows"
        let columnsMatch = (product.columnCount == matrix2.columnCount) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries") <- forAll {
      (matrix1: SimpleMatrix, matrix2: SimpleMatrix) in
      return (matrix1.columnCount == matrix2.rowCount) ==> {
        guard let product = matrix1 * matrix2 else {
          return false
        }
        
        return product.rows.mapAnd {
          (row) in
          return product.columns.mapAnd {
            (column) in
            return product[row,column] == matrix1.columns.reduce(0) {
              (acc: Float, idx: Int) in
              return acc + (matrix1[row, idx]! * matrix2[idx, column]!)
            }
          }
        }
      }
    }
  }
  
  // Mark: Additional methods
  
  func testInit_trace() {
    property("invalid dimensions fail") <- false
    
    property("dimensions") <- false
    
    property("entries") <- false
  }
  
  func testIdentity() {
    property("invalid dimensions fail") <- false
    
    property("dimensions") <- false
    
    property("entries") <- false
  }

}
