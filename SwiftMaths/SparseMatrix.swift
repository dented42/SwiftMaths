//
//  SparseMatrix.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/12/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

final class SparseMatrix: Matrix {  
  
  var rows: Int
  var columns: Int
  
  init(rows: Int, columns: Int) {
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
  
  subscript(r: Int, c: Int) -> Float? {
    get {
      return nil
    }
    set {
      
    }
  }
  
  func transpose() -> SparseMatrix {
    return self
  }
  
  func row(_: Int) -> SparseMatrix? {
    return self
  }
  
  func column(_: Int) -> SparseMatrix? {
    return self
  }
  
  func array(fromRow: Int) -> [Float]? {
    return []
  }
  
  func array(fromColumn: Int) -> [Float]? {
    return []
  }
  
  func subMatrix(rows: IndexSet) -> SparseMatrix? {
    return self
  }
  
  func subMatrix(columns: IndexSet) -> SparseMatrix? {
    return self
  }
  
  func subMatrix(rows: IndexSet, columns: IndexSet) -> SparseMatrix? {
    return self
  }
  
  static func *(lhs: Float, rhs: SparseMatrix) -> SparseMatrix {
    return rhs
  }
  
  static func *(lhs: SparseMatrix, rhs: Float) -> SparseMatrix {
    return lhs
  }
  
  static func *(lhs: SparseMatrix, rhs: SparseMatrix) -> SparseMatrix? {
    return nil
  }
  
  static func +(lhs: SparseMatrix, rhs: SparseMatrix) -> Self? {
    return nil
  }
  
  static func -(lhs: SparseMatrix, rhs: SparseMatrix) -> Self? {
    return nil
  }
  
}
