//
//  Matrix.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/12/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

public protocol Matrix {
  
  init?(rows: Int, columns: Int)
  
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
    return nil
  }
  
  public static func identity(size: Int) -> Self? {
    return nil
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
  
  public func subMatrix(rows: IndexSet) -> SimpleMatrix? {
    return nil
  }
  
  public func subMatrix(columns: IndexSet) -> SimpleMatrix? {
    return nil
  }
  
  public func subMatrix(rows: IndexSet, columns: IndexSet) -> SimpleMatrix? {
    return nil
  }
  
  public func transpose() -> Self {
    var trans = Self(rows: columnCount, columns: rowCount)!
    
    for row in rows {
      for column in columns {
        trans[row, column] = self[column, row]
      }
    }
    
    return trans
  }
  
  public static func *(lhs: Float, rhs: Self) -> Self {
    return rhs
  }
  
  public static func *(lhs: Self, rhs: Float) -> Self {
    return lhs
  }
  
  public static func +(lhs: Self, rhs: Self) -> Self? {
    guard (lhs.rowCount == rhs.rowCount) && (lhs.columnCount == rhs.columnCount) else {
      return nil
    }
    
    return nil
    
  }
  
  public static func -(lhs: Self, rhs: Self) -> Self? {
    return nil
  }
  
  public static func *(lhs: Self, rhs: Self) -> Self? {
    return nil
  }
  
}
