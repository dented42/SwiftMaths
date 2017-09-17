//
//  Sequence.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/17/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

public extension Sequence {
  public func mapAnd(_ f: (Element) -> Bool) -> Bool {
    return self.reduce(true) {
      (acc: Bool, element: Element) in
      return acc && f(element)
    }
  }
  
  public func mapOr(_ f: (Element) -> Bool) -> Bool {
    return self.reduce(false) {
      (acc: Bool, element: Element) in
      return acc || f(element)
    }
  }
}
