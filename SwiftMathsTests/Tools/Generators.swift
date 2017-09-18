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
  
  static func gen(from: Int = 0, to: Int) -> Gen<Int> {
    return Gen<Int>.fromElements(in: from...to)
  }
}

extension Float {
  static var unitGen: Gen<Float> {
    return Gen<Float>.chooseAny().suchThat {
      (f) in
      return (f > 0) && (f < 1)
    }
  }
}

func wrap<E>(_ arrayGen: Gen<[E]>) -> Gen<ArrayOf<E>> {
  return arrayGen.map { return ArrayOf($0) }
}
