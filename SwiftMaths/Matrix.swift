//
//  Matrix.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/12/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import FortlogicFoundation
import Foundation

public protocol Matrix: Equatable {
  
  init?(rows: Int, columns: Int)
  init?(row: [Float])
  init?(column: [Float])
  
  var rowCount: Int { get }
  var columnCount: Int { get }
  
  var count: Int { get }
  
  var rowIndices: CountableRange<Int> { get }
  var columnIndices: CountableRange<Int> { get }
  
  subscript(r: Int, c: Int) -> Float? { get set }
  
  func row(_: Int) -> Self?
  func column(_: Int) -> Self?
  
  func array(fromRow: Int) -> [Float]?
  func array(fromColumn: Int) -> [Float]?
  
  func subMatrix(rows: IndexSet) -> Self?
  func subMatrix(columns: IndexSet) -> Self?
  func subMatrix(rows: IndexSet, columns: IndexSet) -> Self?
  
  func transpose() -> Self
  
  static func *(lhs: Float, rhs: Self) -> Self
  static func *(lhs: Self, rhs: Float) -> Self
  
  static func +(lhs: Self, rhs: Self) -> Self?
  static func -(lhs: Self, rhs: Self) -> Self?
  static func *(lhs: Self, rhs: Self) -> Self?
  
}

// MARK: Extensions

public extension Matrix {
  
  public init?(trace: [Float]) {
    guard trace.count > 0 else {
      return nil
    }
    
    self.init(rows: trace.count, columns: trace.count)!
    
    for idx in trace.indices {
      self[idx,idx] = trace[idx]
    }
  }
  
  public static func identity(size: Int) -> Self? {
    guard size > 0 else {
      return nil
    }
    return Self(trace: Array(repeating: 1, count: size))
  }
  
  public func plus(_ other: Self) -> Self? {
    return self + other
  }
  
  public func minus(_ other: Self) -> Self? {
    return self - other
  }
  
  public func multiply(_ other: Self) -> Self? {
    return self * other
  }
  
}

// MARK: Containers

open class MatrixBox<M: Matrix>: Matrix {
  
  private var matrix: M
  
  required public init?(rows: Int, columns: Int) {
    guard let mat = M(rows: rows, columns: columns) else {
      return nil
    }
    self.matrix = mat
  }
  
  public required init?(row: [Float]) {
    guard let mat = M(row: row) else {
      return nil
    }
    self.matrix = mat
  }
  
  public required init?(column: [Float]) {
    guard let mat = M(column: column) else {
      return nil
    }
    self.matrix = mat
  }
  
  required public init(matrix: M) {
    self.matrix = matrix
  }
  
  required convenience public init?(maybe: M?) {
    guard let mat = maybe else { return nil }
    self.init(matrix: mat)
  }
  
  public final var rowCount: Int { return matrix.rowCount }
  public final var columnCount: Int { return matrix.columnCount }
  
  public final var count: Int { return matrix.count }
  
  public final var rowIndices: CountableRange<Int> { return matrix.rowIndices }
  public final var columnIndices: CountableRange<Int> { return matrix.columnIndices }
  
  public final subscript(r: Int, c: Int) -> Float? {
    get {
      return matrix[r,c]
    }
    set(v) {
      matrix[r,c] = v
    }
  }
  
  public final func row(_ r: Int) -> Self? { return matrix.row(r)?.boxed() }
  public final func column(_ c: Int) -> Self? { return matrix.column(c)?.boxed() }
  
  public final func array(fromRow row: Int) -> [Float]? { return matrix.array(fromRow: row) }
  public final func array(fromColumn column: Int) -> [Float]? { return matrix.array(fromColumn: column) }
  
  public final func subMatrix(rows: IndexSet) -> Self? { return matrix.subMatrix(rows: rows)?.boxed() }
  public final func subMatrix(columns: IndexSet) -> Self? { return matrix.subMatrix(columns: columns)?.boxed() }
  public final func subMatrix(rows: IndexSet, columns: IndexSet) -> Self? { return matrix.subMatrix(rows: rows, columns: columns)?.boxed() }
  
  public final func transpose() -> Self { return matrix.transpose().boxed() }
  
  public static func *(lhs: Float, rhs: MatrixBox) -> Self { return (lhs * rhs.matrix).boxed() }
  public static func *(lhs: MatrixBox, rhs: Float) -> Self { return (lhs.matrix * rhs).boxed() }

  public static func ==(lhs: MatrixBox, rhs: MatrixBox) -> Bool { return lhs.matrix == rhs.matrix }

  public static func +(lhs: MatrixBox, rhs: MatrixBox) -> Self? { return (lhs.matrix + rhs.matrix)?.boxed() }
  public static func -(lhs: MatrixBox, rhs: MatrixBox) -> Self? { return (lhs.matrix - rhs.matrix)?.boxed() }
  public static func *(lhs: MatrixBox, rhs: MatrixBox) -> Self? { return (lhs.matrix * rhs.matrix)?.boxed() }
}

public extension Matrix {
 func boxed<MBox: MatrixBox<Self>>() -> MBox {
    return MBox(matrix: self)
  }
}

public final class AnyMatrix: Matrix {
  required public init?(rows: Int, columns: Int) { return nil }
  required public init?(row: [Float]) { return nil }
  required public init?(column: [Float]) { return nil }
  
  public let matrixType: String
  
  private let _matrix: Any
  private let _rowCount: () -> Int
  private let _columnCount: () -> Int
  private let _count: () -> Int
  private let _rowsIndices: () -> CountableRange<Int>
  private let _columnIndices: () -> CountableRange<Int>
  private let _subscript_get: (Int,Int) -> Float?
  private let _subscript_set: (Int,Int,Float?) -> ()
  private let _row_idx: (Int) -> AnyMatrix?
  private let _column_idx: (Int) -> AnyMatrix?
  private let _array_fromRow: (Int) -> [Float]?
  private let _array_fromColumn: (Int) -> [Float]?
  private let _submatrix_rows: (IndexSet) -> AnyMatrix?
  private let _submatrix_columns: (IndexSet) -> AnyMatrix?
  private let _submatrix_rows_columns: (IndexSet,IndexSet) -> AnyMatrix?
  private let _transpose: () -> AnyMatrix
  private let _multiply_scalar_left: (Float) -> AnyMatrix
  private let _multiply_scalar_right: (Float) -> AnyMatrix
  private let _equals: (AnyMatrix) -> Bool
  private let _plus: (AnyMatrix) -> AnyMatrix?
  private let _minus: (AnyMatrix) -> AnyMatrix?
  private let _multiply: (AnyMatrix) -> AnyMatrix?
  
  required public init<M: Matrix>(matrix m: M) {
    var matrix = m
    matrixType = "\(type(of: matrix))"
    _matrix = matrix
    _rowCount = { return matrix.rowCount }
    _columnCount = { return matrix.columnCount }
    _count = { return matrix.count }
    _rowsIndices = { return matrix.rowIndices }
    _columnIndices = { return matrix.columnIndices }
    _subscript_get = { (r,c) in return matrix[r,c] }
    _subscript_set = { (r,c,v) in matrix[r,c] = v }
    _row_idx = { (idx) in return AnyMatrix(maybe: matrix.row(idx)) }
    _column_idx = { (idx) in return AnyMatrix(maybe: matrix.column(idx)) }
    _array_fromRow = { (idx) in return matrix.array(fromRow: idx) }
    _array_fromColumn = { (idx) in return matrix.array(fromColumn: idx) }
    _submatrix_rows = { (rows) in return AnyMatrix(maybe: matrix.subMatrix(rows: rows)) }
    _submatrix_columns = { (cols) in return AnyMatrix(maybe: matrix.subMatrix(columns: cols)) }
    _submatrix_rows_columns = { return AnyMatrix(maybe: matrix.subMatrix(rows: $0, columns: $1)) }
    _transpose = { return AnyMatrix(matrix: matrix.transpose()) }
    _multiply_scalar_left = { (scalar) in return AnyMatrix(matrix: scalar * matrix) }
    _multiply_scalar_right = { (scalar) in return AnyMatrix(matrix: matrix * scalar) }
    _equals = { (other) in
      if let otherMatrix = other._matrix as? M {
        return matrix == otherMatrix
      } else {
        return false
      }
    }
    _plus = { (other) in
      if let otherMatrix = other._matrix as? M {
        return AnyMatrix(maybe: matrix.plus(otherMatrix))
      } else {
        return nil
      }
    }
    _minus = { (other) in
      if let otherMatrix = other._matrix as? M {
        return AnyMatrix(maybe: matrix.minus(otherMatrix))
      } else {
        return nil
      }
    }
    _multiply = { (other) in
      if let otherMatrix = other._matrix as? M {
        return AnyMatrix(maybe: matrix.multiply(otherMatrix))
      } else {
        return nil
      }
    }
  }
  
  required public init(any m: AnyMatrix) {
    matrixType = m.matrixType
    _matrix = m._matrix
    _rowCount = m._rowCount
    _columnCount = m._columnCount
    _count = m._count
    _rowsIndices = m._rowsIndices
    _columnIndices = m._columnIndices
    _subscript_get = m._subscript_get
    _subscript_set = m._subscript_set
    _row_idx = m._row_idx
    _column_idx = m._column_idx
    _array_fromRow = m._array_fromRow
    _array_fromColumn = m._array_fromColumn
    _submatrix_rows = m._submatrix_rows
    _submatrix_columns = m._submatrix_columns
    _submatrix_rows_columns = m._submatrix_rows_columns
    _transpose = m._transpose
    _multiply_scalar_left = m._multiply_scalar_left
    _multiply_scalar_right = m._multiply_scalar_right
    _equals = m._equals
    _plus = m._plus
    _minus = m._minus
    _multiply = m._multiply
  }
  
  public convenience init?<M: Matrix>(maybe m: M?) {
    if let matrix = m {
      self.init(matrix: matrix)
    } else {
      return nil
    }
  }
  
  public func unwrap<M: Matrix>() -> M? {
    return _matrix as? M
  }
  
  public func unwrap<M: Matrix>(like: M) -> M? {
    return _matrix as? M
  }
  
  public func unwrap<M: Matrix>(as: M.Type) -> M? {
    return _matrix as? M
  }
  
  public var rowCount: Int { return _rowCount() }
  public var columnCount: Int { return _columnCount() }
  
  public var count: Int { return _count() }
  
  public var rowIndices: CountableRange<Int> { return _rowsIndices() }
  public var columnIndices: CountableRange<Int> { return _columnIndices() }
  
  public subscript(r: Int, c: Int) -> Float? {
    get { return _subscript_get(r,c) }
    set(v) { return _subscript_set(r,c,v) } }
  
  public func row(_ idx: Int) -> AnyMatrix? { return _row_idx(idx) }
  public func column(_ idx: Int) -> AnyMatrix? { return _column_idx(idx) }
  
  public func array(fromRow idx : Int) -> [Float]? { return _array_fromRow(idx) }
  public func array(fromColumn idx: Int) -> [Float]? { return _array_fromColumn(idx) }
  
  public func subMatrix(rows: IndexSet) -> AnyMatrix? { return _submatrix_rows(rows) }
  public func subMatrix(columns: IndexSet) -> AnyMatrix? { return _submatrix_columns(columns) }
  public func subMatrix(rows: IndexSet, columns: IndexSet) -> AnyMatrix? { return _submatrix_rows_columns(rows,columns) }

  public func transpose() -> AnyMatrix { return _transpose() }

  public static func *(lhs: Float, rhs: AnyMatrix) -> AnyMatrix { return rhs._multiply_scalar_left(lhs) }
  public static func *(lhs: AnyMatrix, rhs: Float) -> AnyMatrix { return lhs._multiply_scalar_right(rhs) }

  public static func ==(lhs: AnyMatrix, rhs: AnyMatrix) -> Bool { return lhs._equals(rhs) }

  public static func +(lhs: AnyMatrix, rhs: AnyMatrix) -> AnyMatrix? { return lhs._plus(rhs) }
  public static func -(lhs: AnyMatrix, rhs: AnyMatrix) -> AnyMatrix? { return lhs._minus(rhs) }
  public static func *(lhs: AnyMatrix, rhs: AnyMatrix) -> AnyMatrix? { return lhs._multiply(rhs) }
}

public extension Matrix {
  public var wrapped: AnyMatrix {
    return AnyMatrix(matrix: self)
  }
}

// MARK: Default Implementations

public extension Matrix {
  
  public init?(row: [Float]) {
    // dimensions must be valid
    guard row.count > 0 else {
      return nil
    }
    
    self.init(rows: 1, columns: row.count)
    
    for idx in row.indices {
      self[0, idx] = row[idx]
    }
  }
  
  public init?(column: [Float]) {
    // dimensions must be valid
    guard column.count > 0 else {
      return nil
    }
    
    self.init(rows: column.count, columns: 1)
    
    for idx in column.indices {
      self[idx, 0] = column[idx]
    }
  }
  
  public var count: Int {
    return rowCount * columnCount
  }
  
  public var rowIndices: CountableRange<Int> {
    return 0..<rowCount
  }
  
  public var columnIndices: CountableRange<Int> {
    return 0..<columnCount
  }
  
  public func row(_ row: Int) -> Self? {
    guard rowIndices.contains(row) else {
      return nil
    }
    
    var mat = Self(rows: 1, columns: columnCount)!
    
    for column in columnIndices {
      mat[0, column] = self[row, column]!
    }
    
    return mat
  }
  
  public func column(_ column: Int) -> Self? {
    guard columnIndices.contains(column) else {
      return nil
    }
    
    var mat = Self(rows: rowCount, columns: 1)!
    
    for row in rowIndices {
      mat[row,0] = self[row, column]!
    }
    
    return mat
  }
  
  public func array(fromRow row: Int) -> [Float]? {
    // the row needs to exist
    guard rowIndices.contains(row) else {
      return nil
    }
    
    return columnIndices.map {
      (column: Int) in
      return self[row, column]!
    }
  }
  
  public func array(fromColumn column: Int) -> [Float]? {
    // the column needs to exist
    guard columnIndices.contains(column) else {
      return nil
    }
    
    return rowIndices.map {
      (row: Int) in
      return self[row, column]!
    }
  }
  
  public func subMatrix(rows rowSet: IndexSet) -> Self? {
    // the rows need to be in the right range
    guard (rowSet.count > 0) && (rowSet.mapAnd{ return rowIndices.contains($0) }) else {
      return nil
    }
    
    let rowIdxs = Array(rowSet).sorted()
    
    var sub = Self(rows: rowIdxs.count, columns: columnCount)!
    
    for row in sub.rowIndices {
      for column in sub.columnIndices {
        sub[row,column] = self[rowIdxs[row], column]
      }
    }
    
    return sub
  }
  
  public func subMatrix(columns columnSet: IndexSet) -> Self? {
    // the columns need to be in the right range
    guard (columnSet.count > 0) && (columnSet.mapAnd{ return columnIndices.contains($0) }) else {
      return nil
    }
    
    let columnIdxs = Array(columnSet).sorted()
    
    var sub = Self(rows: rowCount, columns: columnIdxs.count)!
    
    for row in sub.rowIndices {
      for column in sub.columnIndices {
        sub[row,column] = self[row, columnIdxs[column]]
      }
    }
    
    return sub
  }
  
  public func subMatrix(rows rowSet: IndexSet, columns columnSet: IndexSet) -> Self? {
    // the rows need to be in the right range
    guard (rowSet.count > 0) && (rowSet.mapAnd{ return rowIndices.contains($0) }) else {
      return nil
    }
    
    // the columns need to be in the right range
    guard (columnSet.count > 0) && (columnSet.mapAnd{ return columnIndices.contains($0) }) else {
      return nil
    }
    
    let rowIdxs = Array(rowSet).sorted()
    let columnIdxs = Array(columnSet).sorted()
    
    var sub = Self(rows: rowSet.count, columns: columnSet.count)!
    
    for row in rowIdxs.indices {
      for column in columnIdxs.indices {
        sub[row,column] = self[rowIdxs[row], columnIdxs[column]]
      }
    }
    
    return sub
  }
  
  public func transpose() -> Self {
    var trans = Self(rows: columnCount, columns: rowCount)!
    
    for row in rowIndices {
      for column in columnIndices {
        trans[column, row] = self[row, column]
      }
    }
    
    return trans
  }
  
  public static func *(lhs: Float, rhs: Self) -> Self {
    var scaled = Self(rows: rhs.rowCount, columns: rhs.columnCount)!
    
    for row in scaled.rowIndices {
      for column in scaled.columnIndices {
        scaled[row,column] = lhs * rhs[row,column]!
      }
    }
    
    return scaled
  }
  
  public static func *(lhs: Self, rhs: Float) -> Self {
    var scaled = Self(rows: lhs.rowCount, columns: lhs.columnCount)!
    
    for row in scaled.rowIndices {
      for column in scaled.columnIndices {
        scaled[row,column] = rhs * lhs[row,column]!
      }
    }
    
    return scaled
  }
  
  public static func +(lhs: Self, rhs: Self) -> Self? {
    guard (lhs.rowCount == rhs.rowCount) && (lhs.columnCount == rhs.columnCount) else {
      return nil
    }
    
    var sum = Self(rows: lhs.rowCount, columns: lhs.columnCount)!
    
    for row in lhs.rowIndices {
      for column in lhs.columnIndices {
        sum[row, column] = lhs[row, column]! + rhs[row, column]!
      }
    }
    
    return sum
  }
  
  public static func -(lhs: Self, rhs: Self) -> Self? {
    guard (lhs.rowCount == rhs.rowCount) && (lhs.columnCount == rhs.columnCount) else {
      return nil
    }
    
    var difference = Self(rows: lhs.rowCount, columns: lhs.columnCount)!
    
    for row in lhs.rowIndices {
      for column in lhs.columnIndices {
        difference[row, column] = lhs[row, column]! - rhs[row, column]!
      }
    }
    
    return difference
  }
  
  public static func *(lhs: Self, rhs: Self) -> Self? {
    guard lhs.columnCount == rhs.rowCount else {
      return nil
    }
    
    var product = Self(rows: lhs.rowCount, columns: rhs.columnCount)!
    
    for row in product.rowIndices {
      for column in product.columnIndices {
        product[row, column] = lhs.columnIndices.reduce(0) {
          (acc: Float, idx: Int) in
          return acc + (lhs[row,idx]! * rhs[idx,column]!)
        }
      }
    }
    
    return product
  }
  
}
