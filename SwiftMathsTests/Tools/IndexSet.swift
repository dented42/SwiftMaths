//
//  IndexSet.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/17/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation
import SwiftCheck

extension IndexSet: Arbitrary {
  
  public static var arbitrary: Gen<IndexSet> {
    return Gen<IndexSet>.compose { (c) in
      let size: UInt = c.generate()
      
      var precursor: Set<Int> = Set()
      for _ in 0...size {
        let val: UInt = c.generate()
        if Int(val) < (Int.max-1) {
          precursor.insert(Int(val))
        }
      }
      
      return IndexSet(precursor)
    }
  }
  
}
