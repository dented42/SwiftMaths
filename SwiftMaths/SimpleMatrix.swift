//
//  SimpleMatrix.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/16/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

public struct SimpleMatrix {
  
  public var rowCount: Int
  
  public var columnCount: Int
  
  private var entries: [Float]
  
  public init?(rows: Int, columns: Int) {
    // dimensions must be valid
    guard (rows > 0) && (columns > 0) else {
      return nil
    }
    
    self.rowCount = rows
    self.columnCount = columns
    self.entries = Array(repeating: 0, count: rows*columns)
  }
  
  public init?(row: [Float]) {
    // dimensions must be valid
    guard row.count > 0 else {
      return nil
    }
    
    self.rowCount = 1
    self.columnCount = row.count
    self.entries = row
  }
  
  public init?(column: [Float]) {
    // dimensions must be valid
    guard column.count > 0 else {
      return nil
    }
    
    self.rowCount = column.count
    self.columnCount = 1
    self.entries = column
  }
  
}

extension SimpleMatrix: Matrix {
  public var count: Int {
    return entries.count
  }
  
  public var rows: CountableRange<Int> {
    return 0..<rowCount
  }
  
  public var columns: CountableRange<Int> {
    return 0..<columnCount
  }
  
  public subscript(r: Int, c: Int) -> Float? {
    get {
      let idx = (columnCount * r) + c
      
      if entries.indices.contains(idx) {
        return entries[idx]
      } else {
        return nil
      }
    }
    set {
      
    }
  }
  
  public func transpose() -> SimpleMatrix {
    var trans = SimpleMatrix(rows: columnCount, columns: rowCount)!
    
    for row in rows {
      for column in columns {
        trans[row, column] = self[column, row]
      }
    }
    
    return trans
  }
  
  public func row(_ row: Int) -> SimpleMatrix? {
    guard rows.contains(row) else {
      return nil
    }
    
    var mat = SimpleMatrix(rows: 1, columns: columnCount)!
    
    for column in columns {
      mat[0, column] = self[row, column]!
    }
    
    return mat
  }
  
  public func column(_ column: Int) -> SimpleMatrix? {
    guard columns.contains(column) else {
      return nil
    }
    
    var mat = SimpleMatrix(rows: rowCount, columns: 1)!
    
    for row in rows {
      mat[row,0] = self[row, column]!
    }
    
    return mat
  }
  
  public func array(fromRow: Int) -> [Float]? {
    return nil
  }
  
  public func array(fromColumn: Int) -> [Float]? {
    return nil
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
  
  public static func *(lhs: Float, rhs: SimpleMatrix) -> SimpleMatrix {
    return rhs
  }
  
  public static func *(lhs: SimpleMatrix, rhs: Float) -> SimpleMatrix {
    return lhs
  }
  
  public static func +(lhs: SimpleMatrix, rhs: SimpleMatrix) -> SimpleMatrix? {
    return nil
  }
  
  public static func -(lhs: SimpleMatrix, rhs: SimpleMatrix) -> SimpleMatrix? {
    return nil
  }
  
  public static func *(lhs: SimpleMatrix, rhs: SimpleMatrix) -> SimpleMatrix? {
    return nil
  }
}
