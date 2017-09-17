//
//  SequenceTests.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/17/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import SwiftCheck
import XCTest

class SequenceTests: XCTestCase {

  func testMapAnd() {
    property("empty sequence maps true") <- forAll {
      (f: ArrowOf<UInt8,Bool>)  in
      
      return [].mapAnd(f.getArrow) == true
    }
    
    property("constant(true) maps true") <- forAll {
      (a: ArrayOf<UInt8>) in
      let arr = a.getArray
      
      return (arr.count > 0) ==> {
        return true == arr.mapAnd { (_) in
          return true
        }
      }
    }
    
    property("constant(false) maps false") <- forAll {
      (a: ArrayOf<UInt8>) in
      let arr = a.getArray
      
      return (arr.count > 0) ==> {
        return false == arr.mapAnd { (_) in
          return false
        }
      }
    }
    
    property("maps false when some items map false") <- forAll {
      (a: ArrayOf<UInt8>, f: ArrowOf<UInt8,Bool>) in
      let arr: [UInt8] = a.getArray
      let fun: (UInt8)->Bool = f.getArrow

      return arr.contains { return fun($0) == false } ==> {
        return arr.mapAnd(fun) == false
      }
    }
  }
  
  func testMapOr() {
    property("empty sequence maps false") <- forAll {
      (f: ArrowOf<UInt,Bool>) in
      
      return [].mapOr(f.getArrow) == false
    }
    
    property("constant(true) maps true") <- forAll {
      (a: ArrayOf<UInt8>) in
      let arr = a.getArray
      
      return (arr.count > 0) ==> {
        return true == arr.mapOr { (_) in
          return true
        }
      }
    }
    
    property("constant(false) maps false") <- forAll {
      (a: ArrayOf<UInt8>) in
      let arr = a.getArray
      
      return (arr.count > 0) ==> {
        return false == arr.mapOr { (_) in
          return false
        }
      }
    }

    property("maps true when some items map true") <- forAll {
      (a: ArrayOf<UInt8>, f: ArrowOf<UInt8,Bool>) in
      let arr = a.getArray
      let fun = f.getArrow
      
      return arr.contains { return fun($0) == true } ==> {
        return arr.mapOr(fun) == true
      }
    }
  }

}
