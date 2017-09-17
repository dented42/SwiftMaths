//
//  SimpleMatrix.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/16/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

public struct SimpleMatrix: Matrix {
  
  public var rows: Int
  
  public var columns: Int
  
  public subscript(r: Int, c: Int) -> Float? {
    get {
      return nil
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
