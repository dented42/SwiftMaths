//
//  Utilities.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/16/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation
import SwiftCheck

extension Int {
  static var naturalsGen: Gen<Int> {
    return Gen<Int>.chooseAny().map { return abs($0) }
  }
  
  static var countingGen: Gen<Int> {
    return Gen<Int>.chooseAny().map { return 1 + abs($0) }
  }
}
