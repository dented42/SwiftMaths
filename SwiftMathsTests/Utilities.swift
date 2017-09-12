//
//  Utilities.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/7/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation
import SwiftCheck

// This should be an extension on Dictionary that makes it Arbitrary when it's keys and values are
// also arbitrary. Swift however does not yet allow extensions to provide conditional protocol
// conformance.
struct UniqueDictionary<Key: Hashable & Arbitrary, Value: Hashable & Arbitrary>: Arbitrary {
  var dictionary: [Key: Value]
  
  var backwards: [Value: Key] {
    var d = Dictionary<Value,Key>()
    for (k,v) in dictionary {
      d[v] = k
    }
    return d
  }
  
  init?(_ d: [Key: Value]) {
    guard d.hasUniqueValues else {
      return nil
    }
    dictionary = d
  }
  
  subscript(key: Key) -> Value? {
    get {
      return dictionary[key]
    }
    set(value) {
      if let value = value {
        if dictionary.values.contains(value) {
        }
      }
    }
  }
  
  public static var arbitrary: Gen<UniqueDictionary<Key, Value>> {
    return Gen<UniqueDictionary<Key,Value>>.compose{ c in
      let size: Int = abs(c.generate()) + 1
      
      var d = Dictionary<Key,Value>()
      var range = Set<Value>()
      
      for _ in 0..<size {
        let key: Key = c.generate()
        let val: Value = c.generate()
        if d[key] == nil {
          if !range.contains(val) {
            d[key] = val
            range.insert(val)
          }
        }
      }
      
      return UniqueDictionary(d)!
    }
  }
}

// An extension on Dictionary that tells when it's values are unique.
extension Dictionary where Value: Hashable {
  var hasUniqueValues: Bool {
    // make a set containing all the values
    let values = Set<Value>(self.values)
    
    // return whether or not the set of values is as big as the set of entries
    return values.count == self.count
  }
  
  var backwards: Dictionary<Value,Key>? {
    var d = [Value:Key]()
    for (k,v) in self {
      if d.keys.contains(v) {
        return nil
      } else {
        d[v] = k
      }
    }
    return d
  }
}

func wrap<E>(_ arrayGen: Gen<[E]>) -> Gen<ArrayOf<E>> {
  return arrayGen.map { return ArrayOf($0) }
}

