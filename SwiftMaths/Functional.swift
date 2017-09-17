//
//  Functional.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/17/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

public func identity<A>(_ x: A) -> A {
  return x
}

public func constant<A,B>(_ x: A) -> ((B) -> A) {
  return { (_: B) in return x }
}
