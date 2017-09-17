//
//  SparseMatrix.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/12/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Accelerate
import Foundation

public final class SparseMatrix: Matrix {  
  
  public var rows: Int
  public var columns: Int
  
  public init(rows: Int, columns: Int) {
    self.rows = rows
    self.columns = columns
  }
  
  init(rowVector columns: Int) {
    self.rows = 1
    self.columns = columns
  }
  
  init(columnVector rows: Int) {
    self.rows = rows
    self.columns = 1
  }
  
  public subscript(r: Int, c: Int) -> Float? {
    get {
      return nil
    }
    set {
      
    }
  }
  
  public func transpose() -> SparseMatrix {
    return self
  }
  
  public func row(_: Int) -> SparseMatrix? {
    return self
  }
  
  public func column(_: Int) -> SparseMatrix? {
    return self
  }
  
  public func array(fromRow: Int) -> [Float]? {
    return []
  }
  
  public func array(fromColumn: Int) -> [Float]? {
    return []
  }
  
  public func subMatrix(rows: IndexSet) -> SparseMatrix? {
    return self
  }
  
  public func subMatrix(columns: IndexSet) -> SparseMatrix? {
    return self
  }
  
  public func subMatrix(rows: IndexSet, columns: IndexSet) -> SparseMatrix? {
    return self
  }
  
  public static func *(lhs: Float, rhs: SparseMatrix) -> SparseMatrix {
    return rhs
  }
  
  public static func *(lhs: SparseMatrix, rhs: Float) -> SparseMatrix {
    return lhs
  }
  
  public static func *(lhs: SparseMatrix, rhs: SparseMatrix) -> SparseMatrix? {
    return nil
  }
  
  public static func +(lhs: SparseMatrix, rhs: SparseMatrix) -> Self? {
    return nil
  }
  
  public static func -(lhs: SparseMatrix, rhs: SparseMatrix) -> Self? {
    return nil
  }
  
}
