//
//  Matrix.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/12/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

public protocol Matrix: Equatable {
  
  init?(rows: Int, columns: Int)
  init?(row: [Float])
  init?(column: [Float])
  
  var rowCount: Int { get }
  var columnCount: Int { get }
  
  var count: Int { get }
  
  var rows: CountableRange<Int> { get }
  var columns: CountableRange<Int> { get }
  
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
  
  public var rows: CountableRange<Int> {
    return 0..<rowCount
  }
  
  public var columns: CountableRange<Int> {
    return 0..<columnCount
  }
  
  public func row(_ row: Int) -> Self? {
    guard rows.contains(row) else {
      return nil
    }
    
    var mat = Self(rows: 1, columns: columnCount)!
    
    for column in columns {
      mat[0, column] = self[row, column]!
    }
    
    return mat
  }
  
  public func column(_ column: Int) -> Self? {
    guard columns.contains(column) else {
      return nil
    }
    
    var mat = Self(rows: rowCount, columns: 1)!
    
    for row in rows {
      mat[row,0] = self[row, column]!
    }
    
    return mat
  }
  
  public func array(fromRow row: Int) -> [Float]? {
    // the row needs to exist
    guard rows.contains(row) else {
      return nil
    }
    
    return columns.map {
      (column: Int) in
      return self[row, column]!
    }
  }
  
  public func array(fromColumn column: Int) -> [Float]? {
    // the column needs to exist
    guard columns.contains(column) else {
      return nil
    }
    
    return rows.map {
      (row: Int) in
      return self[row, column]!
    }
  }
  
  public func subMatrix(rows rowSet: IndexSet) -> Self? {
    // the rows need to be in the right range
    guard (rowSet.count > 0) && (rowSet.mapAnd{ return rows.contains($0) }) else {
      return nil
    }
    
    let rowIdxs = Array(rowSet).sorted()
    
    var sub = Self(rows: rowIdxs.count, columns: columnCount)!
    
    for row in sub.rows {
      for column in sub.columns {
        sub[row,column] = self[rowIdxs[row], column]
      }
    }
    
    return sub
  }
  
  public func subMatrix(columns columnSet: IndexSet) -> Self? {
    // the columns need to be in the right range
    guard (columnSet.count > 0) && (columnSet.mapAnd{ return columns.contains($0) }) else {
      return nil
    }
    
    let columnIdxs = Array(columnSet).sorted()
    
    var sub = Self(rows: rowCount, columns: columnIdxs.count)!
    
    for row in sub.rows {
      for column in sub.columns {
        sub[row,column] = self[row, columnIdxs[column]]
      }
    }
    
    return sub
  }
  
  public func subMatrix(rows rowSet: IndexSet, columns columnSet: IndexSet) -> Self? {
    // the rows need to be in the right range
    guard (rowSet.count > 0) && (rowSet.mapAnd{ return rows.contains($0) }) else {
      return nil
    }
    
    // the columns need to be in the right range
    guard (columnSet.count > 0) && (columnSet.mapAnd{ return columns.contains($0) }) else {
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
    
    for row in rows {
      for column in columns {
        trans[column, row] = self[row, column]
      }
    }
    
    return trans
  }
  
  public static func *(lhs: Float, rhs: Self) -> Self {
    var scaled = Self(rows: rhs.rowCount, columns: rhs.columnCount)!
    
    for row in scaled.rows {
      for column in scaled.columns {
        scaled[row,column] = lhs * rhs[row,column]!
      }
    }
    
    return scaled
  }
  
  public static func *(lhs: Self, rhs: Float) -> Self {
    var scaled = Self(rows: lhs.rowCount, columns: lhs.columnCount)!
    
    for row in scaled.rows {
      for column in scaled.columns {
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
    
    for row in lhs.rows {
      for column in lhs.columns {
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
    
    for row in lhs.rows {
      for column in lhs.columns {
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
    
    for row in product.rows {
      for column in product.columns {
        product[row, column] = lhs.columns.reduce(0) {
          (acc: Float, idx: Int) in
          return acc + (lhs[row,idx]! * rhs[idx,column]!)
        }
      }
    }
    
    return product
  }
  
}
