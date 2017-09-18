//
//  SimpleMatrix.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/16/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

public struct SimpleMatrix: Matrix {
  
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
  
  public static func ==(lhs: SimpleMatrix, rhs: SimpleMatrix) -> Bool {
    return (lhs.rowCount == rhs.rowCount) &&
      (lhs.columnCount == rhs.columnCount) &&
      (lhs.entries == rhs.entries)
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
    set(v) {
      let value: Float = (v == nil) ? 0 : v!
      let idx = (columnCount * r) + c
      if entries.indices.contains(idx) {
        entries[idx] = value
      }
    }
  }
}
