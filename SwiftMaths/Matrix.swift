//
//  Matrix.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/12/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

public protocol Matrix {
  
  var rows: Int { get }
  var columns: Int { get }
  
  var count: Int { get }
  
  subscript(r: Int, c: Int) -> Float? { get set }
  
  func transpose() -> Self //{ get }
  
  func row(_: Int) -> Self?
  func column(_: Int) -> Self?
  
  func array(fromRow: Int) -> [Float]?
  func array(fromColumn: Int) -> [Float]?
  
  func subMatrix(rows: IndexSet) -> Self?
  func subMatrix(columns: IndexSet) -> Self?
  func subMatrix(rows: IndexSet, columns: IndexSet) -> Self?
  
  static func *(lhs: Float, rhs: Self) -> Self
  static func *(lhs: Self, rhs: Float) -> Self
  
  static func +(lhs: Self, rhs: Self) -> Self?
  static func -(lhs: Self, rhs: Self) -> Self?
  static func *(lhs: Self, rhs: Self) -> Self?
  
}
