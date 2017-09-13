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
  
  subscript(r: Int, c: Int) -> Float? { get set }
  
  var transpose: Matrix { get }
  
  func row(_: Int) -> Matrix
  func column(_: Int) -> Matrix
  
  func array(fromRow: Int) -> [Float]
  func array(fromColumn: Int) -> [Float]
  
  func subMatrix(rows: IndexSet) -> Matrix
  func subMatrix(columns: IndexSet) -> Matrix
  func subMatrix(rows: IndexSet, columns: IndexSet) -> Matrix
  
  static func +(lhs: Matrix, rhs: Matrix) -> Matrix?
  static func -(lhs: Matrix, rhs: Matrix) -> Matrix?
  static func *(lhs: Matrix, rhs: Matrix) -> Matrix?
  
}
