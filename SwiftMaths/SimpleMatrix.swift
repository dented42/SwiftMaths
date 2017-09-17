//
//  SimpleMatrix.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/16/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

public struct SimpleMatrix {
  
  public var rows: Int
  
  public var columns: Int
  
  private var entries: [Float]
  
  public init?(rows: Int, columns: Int) {
    // dimensions must be valid
    guard (rows > 0) && (columns > 0) else {
      return nil
    }
    
    self.rows = rows
    self.columns = columns
    self.entries = Array(repeating: 0, count: rows*columns)
  }
  
  public init?(row: [Float]) {
    // dimensions must be valid
    guard row.count > 0 else {
      return nil
    }
    
    self.rows = 1
    self.columns = row.count
    self.entries = row
  }
  
  public init?(column: [Float]) {
    self.rows = column.count
    self.columns = 1
    self.entries = []
  }
  
}

extension SimpleMatrix: Matrix {
  public var count: Int {
    return entries.count
  }
  
  public subscript(r: Int, c: Int) -> Float? {
    get {
      let rowOffset = columns * r
      return entries[rowOffset + c]
    }
    set {
      
    }
  }
  
  public func transpose() -> SimpleMatrix {
    return self
  }
  
  public func row(_: Int) -> SimpleMatrix? {
    return nil
  }
  
  public func column(_: Int) -> SimpleMatrix? {
    return nil
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
