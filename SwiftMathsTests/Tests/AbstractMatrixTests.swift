//
//  AbstractMatrixTests.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/17/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import SwiftCheck
import XCTest

import SwiftMaths

class AbstractMatrixTests: XCTestCase {
  
  // MARK: Abstract methods
  
  open var matrixGenerator: Gen<AnyMatrix> {
    preconditionFailure("AbstractMatrixTests must provide an implementation of matrixGenerator.")
  }
  
  open func matrix_init(row: [Float]) -> AnyMatrix? {
    preconditionFailure("AbstractMatrixTests must provide an implementation of matrix_init(row:).")
  }
  
  open func matrix_init(column: [Float]) -> AnyMatrix? {
    preconditionFailure("AbstractMatrixTests must provide an implementation of matrix_init(column:).")
  }
  
  // MARK: Abstract test checker
  
  func testAbstractTestClass() {
    AssertAbstractTestClass(name: "SwiftMathsTests.AbstractMatrixTests")
  }
  
  // MARK: Default implementation tests
  
  func testInit_row() {
    property("empty vector is rejected") <- {
      return SimpleMatrix(row: []) == nil
    }
    
    property("dimensions are correct") <- forAll {
      (rowHolder: ArrayOf<Float>) in
      let row = rowHolder.getArray
      return (row.count > 0) ==> {
        let m = self.matrix_init(row: row)
        
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
        guard let m = self.matrix_init(row: row) else {
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
      return matrix_init(column: []) == nil
    }
    
    property("dimensions are correct") <- forAll {
      (columnHolder: ArrayOf<Float>) in
      let column = columnHolder.getArray
      return (column.count > 0) ==> {
        let m = self.matrix_init(column: column)
        
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
        guard let m = self.matrix_init(column: column) else {
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
    property("count is correct") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      
      return mat.count == (mat.rowCount * mat.columnCount)
    }
  }
  
  func testRowIndices() {
    property("correct lower bound") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return mat.rowIndices.first == 0
    }
    
    property("correct upper bound") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return mat.rowIndices.last == (mat.rowCount - 1)
    }
  }
  
  func testColumnIndices() {
    property("correct lower bound") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return mat.columnIndices.first == 0
    }
    
    property("correct upper bound") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return mat.columnIndices.last == (mat.columnCount - 1)
    }
  }

  
  func testRow() {
    property("invalid rows are rejected") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll { (rowIdx: Int) in
        return !mat.rowIndices.contains(rowIdx) ==> {
          return mat.row(rowIdx) == nil
        }
      }
    }
    
    property("dimensions") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll(mat.rowIndexGen) {
        (rowIdx: Int) in
        guard let row = mat.row(rowIdx) else {
          return false
        }
        
        let rowsMatch = (row.rowCount == 1) <?> "rows"
        let columnsMatch = (row.columnCount == mat.columnCount) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("contents") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll(mat.rowIndexGen) {
        (rowIdx: Int) in
        guard let row = mat.row(rowIdx) else {
          return false
        }
        
        return row.columnIndices.mapAnd {
          (idx) in
          return row[0, idx] == mat[rowIdx, idx]
        }
      }
    }
  }
  
  func testColumn() {
    property("invalid columns are rejected") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll { (columnIdx: Int) in
        return !mat.columnIndices.contains(columnIdx) ==> {
          return mat.column(columnIdx) == nil
        }
      }
    }
    
    property("dimensions") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll(mat.columnIndexGen) {
        (columnIdx: Int) in
        guard let column = mat.column(columnIdx) else {
          return false
        }
        
        let rowsMatch = (column.rowCount == mat.rowCount) <?> "rows"
        let columnsMatch = (column.columnCount == 1) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("contents") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll(mat.columnIndexGen) {
        (columnIdx: Int) in
        guard let column = mat.column(columnIdx) else {
          return false
        }
        
        return column.rowIndices.mapAnd {
          (idx) in
          return column[idx, 0] == mat[idx, columnIdx]
        }
      }
    }
  }
  
  func testArrayFromRow() {
    property("invalid rows are rejected") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll { (rowIdx: Int) in
        return !mat.rowIndices.contains(rowIdx) ==> {
          return mat.array(fromRow: rowIdx) == nil
        }
      }
    }
    
    property("dimensions") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll(mat.rowIndexGen) {
        (rowIdx: Int) in
        guard let row = mat.array(fromRow: rowIdx) else {
          return false
        }
        
        return row.count == mat.columnCount
      }
    }
    
    property("contents") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll(mat.rowIndexGen) {
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
    property("invalid columns are rejected") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll { (columnIdx: Int) in
        return !mat.columnIndices.contains(columnIdx) ==> {
          return mat.array(fromColumn: columnIdx) == nil
        }
      }
    }
    
    property("dimensions") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll(mat.columnIndexGen) {
        (columnIdx: Int) in
        guard let column = mat.array(fromColumn: columnIdx) else {
          return false
        }
        
        return column.count == mat.rowCount
      }
    }
    
    property("contents") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      return forAll(mat.columnIndexGen) {
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
    property("empty row sets are rejected") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return matrix.subMatrix(rows: IndexSet()) == nil
    }
    
    property("invalid indices are rejected") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (rowSet: IndexSet) in
        return (rowSet.contains { return !matrix.rowIndices.contains($0) }) ==> {
          return matrix.subMatrix(rows: rowSet) == nil
        }
      }
    }
    
    property("dimensions match") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (rowSet: IndexSet) in
        return (rowSet.mapAnd { return matrix.rowIndices.contains($0) }) ==> {
          guard let subMatrix = matrix.subMatrix(rows: rowSet) else {
            return false
          }
          
          let rowsMatch = (subMatrix.rowCount == rowSet.count) <?> "rows"
          let columnsMatch = (subMatrix.columnCount == matrix.columnCount) <?> "columns"
          return rowsMatch ^&&^ columnsMatch
        }
      }
    }
    
    property("entries match") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (rowSet: IndexSet) in
        return (rowSet.mapAnd { return matrix.rowIndices.contains($0) }) ==> {
          guard let subMatrix = matrix.subMatrix(rows: rowSet) else {
            return false
          }
          
          let rowIdxs = Array(rowSet).sorted()
          
          return rowIdxs.indices.mapAnd {
            (row) in
            return subMatrix.columnIndices.mapAnd {
              (column) in
              return subMatrix[row,column] == matrix[rowIdxs[row],column]
            }
          }
        }
      }
    }
  }
  
  func testSubMatrixColumns() {
    property("empty column sets are rejected") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return matrix.subMatrix(columns: IndexSet()) == nil
    }
    
    property("invalid indices are rejected") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (columnSet: IndexSet) in
        return (columnSet.contains { return !matrix.columnIndices.contains($0) }) ==> {
          return matrix.subMatrix(columns: columnSet) == nil
        }
      }
    }
    
    property("dimensions match") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (columnSet: IndexSet) in
        return (columnSet.mapAnd { return matrix.columnIndices.contains($0) }) ==> {
          guard let subMatrix = matrix.subMatrix(columns: columnSet) else {
            return false
          }
          
          let rowsMatch = (subMatrix.rowCount == matrix.rowCount) <?> "rows"
          let columnsMatch = (subMatrix.columnCount == columnSet.count) <?> "columns"
          return rowsMatch ^&&^ columnsMatch
        }
      }
    }
    
    property("entries match") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (columnSet: IndexSet) in
        return (columnSet.mapAnd { return matrix.columnIndices.contains($0) }) ==> {
          guard let subMatrix = matrix.subMatrix(columns: columnSet) else {
            return false
          }
          
          let columnIdxs = Array(columnSet).sorted()
          
          return subMatrix.rowIndices.mapAnd {
            (row) in
            return columnIdxs.indices.mapAnd {
              (column) in
              return subMatrix[row,column] == matrix[row,columnIdxs[column]]
            }
          }
        }
      }
    }
  }
  
  func testSubMatrixRowsColumns() {
    property("empty row sets are rejected") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (columnSet: IndexSet) in
        return matrix.subMatrix(rows: IndexSet(), columns: columnSet) == nil
      }
    }
    
    property("empty column sets are rejected") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (rowSet: IndexSet) in
        return matrix.subMatrix(rows: rowSet, columns: IndexSet()) == nil
      }
    }
    
    property("invalid row indices are rejected") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (rowSet: IndexSet, columnSet: IndexSet) in
        return (rowSet.contains { return !matrix.rowIndices.contains($0) }) ==> {
          return matrix.subMatrix(rows: rowSet, columns: columnSet) == nil
        }
      }
    }
    
    property("invalid column sets are rejected") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (rowSet: IndexSet, columnSet: IndexSet) in
        return (columnSet.contains { return !matrix.columnIndices.contains($0) }) ==> {
          return matrix.subMatrix(rows: rowSet, columns: columnSet) == nil
        }
      }
    }
    
    property("dimensions match") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (rowSet: IndexSet, columnSet: IndexSet) in
        return (rowSet.mapAnd { return matrix.rowIndices.contains($0) }) ==> {
          return (columnSet.mapAnd { return matrix.columnIndices.contains($0) }) ==> {
            guard let subMatrix = matrix.subMatrix(rows: rowSet, columns: columnSet) else {
              return false
            }
            
            let rowsMatch = (subMatrix.rowCount == rowSet.count) <?> "rows"
            let columnsMatch = (subMatrix.columnCount == columnSet.count) <?> "columns"
            return rowsMatch ^&&^ columnsMatch
          }
        }
      }
    }
    
    property("entries match") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (rowSet: IndexSet, columnSet: IndexSet) in
        return (rowSet.mapAnd { return matrix.rowIndices.contains($0) }) ==> {
          return (columnSet.mapAnd { return matrix.columnIndices.contains($0) }) ==> {
            guard let subMatrix = matrix.subMatrix(rows: rowSet, columns: columnSet) else {
              return false
            }
            
            let rowIdxs = Array(rowSet).sorted()
            let columnIdxs = Array(columnSet).sorted()
            
            return rowIdxs.indices.mapAnd {
              (row) in
              return columnIdxs.indices.mapAnd {
                (column) in
                return subMatrix[row,column] == matrix[rowIdxs[row],columnIdxs[column]]
              }
            }
          }
        }
      }
    }
  }
  
  func testTranspose() {
    property("dimensions") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      
      let trans = mat.transpose()
      
      let rowsMatch = (trans.rowCount == mat.columnCount) <?> "rows"
      let columnsMatch = (trans.columnCount == mat.rowCount) <?> "columns"
      
      return rowsMatch ^&&^ columnsMatch
    }
    
    property("entries") <- forAll(self.matrixGenerator) {
      (mat: AnyMatrix) in
      
      let trans = mat.transpose()
      
      return trans.rowIndices.mapAnd {
        (row) in
        return trans.columnIndices.mapAnd {
          (column) in
          return trans[row, column] == mat[column, row]
        }
      }
    }
    
    property("transpose^2 = id") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return matrix.transpose().transpose() == matrix
    }
  }
  
  func testScalarMultiply() {
    property("dimensions") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (scalar: Float) in
        let scaled = scalar * matrix
        
        let rowsMatch = (scaled.rowCount == matrix.rowCount) <?> "rows"
        let columnsMatch = (scaled.columnCount == matrix.columnCount) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (scalar: Float) in
        let scaled = scalar * matrix
        
        return scaled.rowIndices.mapAnd {
          (row) in
          return scaled.columnIndices.mapAnd {
            (column) in
            return scaled[row,column] == (matrix[row,column]! * scalar)
          }
        }
      }
    }
  }
  
  func testMultiplyScalar() {
    property("dimensions") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (scalar: Float) in
        let scaled =  matrix * scalar
        
        let rowsMatch = (scaled.rowCount == matrix.rowCount) <?> "rows"
        let columnsMatch = (scaled.columnCount == matrix.columnCount) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries") <- forAll(self.matrixGenerator) {
      (matrix: AnyMatrix) in
      return forAll { (scalar: Float) in
        let scaled =  matrix * scalar
        
        return scaled.rowIndices.mapAnd {
          (row) in
          return scaled.columnIndices.mapAnd {
            (column) in
            return scaled[row,column] == (matrix[row,column]! * scalar)
          }
        }
      }
    }
  }
  
  func testAdd() {
    property("invalid dimensions fail") <- forAll(self.matrixGenerator, self.matrixGenerator) {
      (mat1: AnyMatrix, mat2: AnyMatrix) in
      return ((mat1.rowCount != mat2.rowCount) && (mat1.columnCount != mat2.columnCount)) ==> {
        return (mat1 + mat2) == nil
      }
    }
    
    property("dimensions") <- forAll(self.matrixGenerator, self.matrixGenerator) {
      (mat1: AnyMatrix, mat2: AnyMatrix) in
      return ((mat1.rowCount == mat2.rowCount) && (mat1.columnCount == mat2.columnCount)) ==> {
        guard let mat3 = mat1 + mat2 else {
          return false
        }
        
        let rowsMatch = (mat3.rowCount == mat1.rowCount) <?> "rows"
        let columnsMatch = (mat3.columnCount == mat1.columnCount) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries") <- forAll(self.matrixGenerator, self.matrixGenerator) {
      (mat1: AnyMatrix, mat2: AnyMatrix) in
      return ((mat1.rowCount == mat2.rowCount) && (mat1.columnCount == mat2.columnCount)) ==> {
        guard let mat3 = mat1 + mat2 else {
          return false
        }
        
        return mat3.rowIndices.mapAnd {
          (row) in
          return mat3.columnIndices.mapAnd {
            (column) in
            return mat3[row,column] == (mat1[row,column]! + mat2[row,column]!)
          }
        }
      }
    }
  }
  
  func testSubtract() {
    property("invalid dimensions fail") <- forAll(self.matrixGenerator, self.matrixGenerator) {
      (mat1: AnyMatrix, mat2: AnyMatrix) in
      return ((mat1.rowCount != mat2.rowCount) && (mat1.columnCount != mat2.columnCount)) ==> {
        return (mat1 - mat2) == nil
      }
    }
    
    property("dimensions") <- forAll(self.matrixGenerator, self.matrixGenerator) {
      (mat1: AnyMatrix, mat2: AnyMatrix) in
      return ((mat1.rowCount == mat2.rowCount) && (mat1.columnCount == mat2.columnCount)) ==> {
        guard let mat3 = mat1 - mat2 else {
          return false
        }
        
        let rowsMatch = (mat3.rowCount == mat1.rowCount) <?> "rows"
        let columnsMatch = (mat3.columnCount == mat1.columnCount) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries") <- forAll(self.matrixGenerator, self.matrixGenerator) {
      (mat1: AnyMatrix, mat2: AnyMatrix) in
      return ((mat1.rowCount == mat2.rowCount) && (mat1.columnCount == mat2.columnCount)) ==> {
        guard let mat3 = mat1 - mat2 else {
          return false
        }
        
        return mat3.rowIndices.mapAnd {
          (row) in
          return mat3.columnIndices.mapAnd {
            (column) in
            return mat3[row,column] == (mat1[row,column]! - mat2[row,column]!)
          }
        }
      }
    }
  }
  
  func testMultiply() {
    property("invalid dimensions fail") <- forAll(self.matrixGenerator, self.matrixGenerator) {
      (matrix1: AnyMatrix, matrix2: AnyMatrix) in
      return (matrix1.columnCount != matrix2.rowCount) ==> {
        return (matrix1 * matrix2) == nil
      }
    }
    
    property("dimensions") <- forAll(self.matrixGenerator, self.matrixGenerator) {
      (matrix1: AnyMatrix, matrix2: AnyMatrix) in
      return (matrix1.columnCount == matrix2.rowCount) ==> {
        guard let product = matrix1 * matrix2 else {
          return false
        }
        
        let rowsMatch = (product.rowCount == matrix1.rowCount) <?> "rows"
        let columnsMatch = (product.columnCount == matrix2.columnCount) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries") <- forAll(self.matrixGenerator, self.matrixGenerator) {
      (matrix1: AnyMatrix, matrix2: AnyMatrix) in
      return (matrix1.columnCount == matrix2.rowCount) ==> {
        guard let product = matrix1 * matrix2 else {
          return false
        }
        
        return product.rowIndices.mapAnd {
          (row) in
          return product.columnIndices.mapAnd {
            (column) in
            return product[row,column] == matrix1.columnIndices.reduce(0) {
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
    property("invalid dimensions fail") <- {
      return SimpleMatrix(trace: []) == nil
    }
    
    property("dimensions") <- forAll {
      (t: ArrayOf<Float>) in
      let trace = t.getArray
      return (trace.count > 0) ==> {
        guard let matrix = SimpleMatrix(trace: trace) else {
          return false
        }
        
        let rowsMatch = (matrix.rowCount == trace.count) <?> "rows"
        let columnsMatch = (matrix.columnCount == trace.count) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries") <- forAll {
      (t: ArrayOf<Float>) in
      let trace = t.getArray
      return (trace.count > 0) ==> {
        guard let matrix = SimpleMatrix(trace: trace) else {
          return false
        }
        
        return matrix.rowIndices.mapAnd {
          (row) in
          return matrix.columnIndices.mapAnd {
            (column) in
            if row == column {
              return matrix[row,column] == trace[row]
            } else {
              return matrix[row,column] == 0
            }
          }
        }
      }
    }
  }
  
  func testIdentity() {
    property("invalid dimensions fail") <- forAll {
      (size: Int) in
      return (size <= 0) ==> {
        return SimpleMatrix.identity(size: size) == nil
      }
    }
    
    property("dimensions") <- forAll {
      (size: Int) in
      return (size > 0) ==> {
        guard let matrix = SimpleMatrix.identity(size: size) else {
          return false
        }
        
        let rowsMatch = (matrix.rowCount == size) <?> "rows"
        let columnsMatch = (matrix.columnCount == size) <?> "columns"
        
        return rowsMatch ^&&^ columnsMatch
      }
    }
    
    property("entries") <- forAll {
      (size: Int) in
      return (size > 0) ==> {
        guard let matrix = SimpleMatrix.identity(size: size) else {
          return false
        }
        
        return matrix.rowIndices.mapAnd {
          (row) in
          return matrix.columnIndices.mapAnd {
            (column) in
            if row == column {
              return matrix[row,column] == 1
            } else {
              return matrix[row,column] == 0
            }
          }
        }
      }
    }
  }
}

// MARK: Arbitrary instances

extension AnyMatrix: Arbitrary {
  public static var arbitrary: Gen<AnyMatrix> {
    preconditionFailure("AnyMatrix doesn't conform to Arbitrary. Supply an explicit generator instead.")
  }
  
  var rowIndexGen: Gen<Int> {
    return Gen<Int>.fromElements(in: ClosedRange(rowIndices))
  }
  
  var columnIndexGen: Gen<Int> {
    return Gen<Int>.fromElements(in: ClosedRange(columnIndices))
  }
}
