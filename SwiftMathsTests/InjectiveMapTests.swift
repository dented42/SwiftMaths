//
//  InjectiveMapTests.swift
//  SwiftMathsTests
//
//  Created by Matias Eyzaguirre on 9/7/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import SwiftCheck
import XCTest

import SwiftMaths

class InjectiveMapTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func testInit() {
    let empty = InjectiveMap<Int,String>();
    
    XCTAssert(empty.count == 0, "New empty dictionary doesn't have 0 items")
    
    property("there are no integers that map in the dictionary") <- forAll {
      (n: Int) in
      return empty[n] == nil
    }
    
    property("there are no strings that map in the dictionary") <- forAll {
      (s: String) in
      return empty[s] == nil
    }
  }
  
  func testInitWithDictionary() {
    property("init fails when keys aren't unique") <- forAll {
      (d: DictionaryOf<String, Int>) in
      // if init succeeded then make sure the dictionary had unique values
      if let _ = InjectiveMap(d.getDictionary) {
        return d.getDictionary.hasUniqueValues == true
      } else {
        return d.getDictionary.hasUniqueValues == false
      }
    }
    
    property("map is the same size as the dictionary it was initialised with") <- forAll {
      (d: DictionaryOf<Int,String>) in
      return d.getDictionary.hasUniqueValues ==> {
        let map = InjectiveMap(d.getDictionary)!
        return map.count == d.getDictionary.count
      }
    }
    
    property("all the (domain,range) pairs correctly map") <- forAll {
      (d: DictionaryOf<Int,String>) in
      return d.getDictionary.hasUniqueValues ==> {
        let map = InjectiveMap(d.getDictionary)!
        return d.getDictionary.reduce(true){
          (soFar: Bool, p: (Int,String)) in
          let success = map.contains(p)
          return soFar && success
        }
      }
    }
    
    property("doesn't contain pairs that aren't from the dictionary") <- forAll {
      (d: DictionaryOf<Int,String>, domain: Int, range: String) in
      return d.getDictionary.hasUniqueValues ==> {
        // the domain and range values should be unique
        return (d.getDictionary[domain] != range) ==> {
          let map = InjectiveMap(d.getDictionary)!
          return !map.contains(domain, range)
        }
      }
    }
    
  }
  
  func testDomain() {
    property("domain contains the right elements") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>) in
      return m.map.domain == Set(m.dict.keys)
    }
  }
  
  func testRange() {
    property("range contains the right elements") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>) in
      return m.map.range == Set(m.dict.values)
    }
  }
  
  func testDomainDictionary() {
    property("domain dictionary contains the right elements") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>) in
      return m.map.domainDictionary == m.dict
    }
  }
  
  func testRangeDictionary() {
    property("range dictionary contains the right elements") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>) in
      return m.map.rangeDictionary == m.backwards
    }
  }
  
  func testCompact() {
    XCTFail() // FIXME: property("removing items increases garbage count")
    
    XCTFail() // FIXME: property("compacting a map with no garbage has no effect")
    
    XCTFail() // FIXME: property("compacting removes all the garbage")
    
    XCTFail() // FIXME: property("compaction doesn't change the domain mapping")
    
    XCTFail() // FIXME: property("compaction doesn't change the range mapping")
  }
  
  func testCount() {
    property("count agrees with domain") <- forAll {
      (m: ArbitraryInjectiveMap<Int,Int>) in
      let map = m.map
      return  map.count == map.domain.count
    }
    
    property("count agrees with range") <- forAll {
      (m: ArbitraryInjectiveMap<Int,Int>) in
      let map = m.map
      return  map.count == map.range.count
    }
    
    property("count agrees with domainDictionary") <- forAll {
      (m: ArbitraryInjectiveMap<Int,Int>) in
      let map = m.map
      return  map.count == map.domainDictionary.count
    }
    
    property("count agrees with rangeDictionary") <- forAll {
      (m: ArbitraryInjectiveMap<Int,Int>) in
      let map = m.map
      return  map.count == map.rangeDictionary.count
    }
  }
  
  func testRemove_domain() {
    property("count decreases by one") <- forAll {
      (m: ArbitraryInjectiveMap<Int,Float>, n: Int) in
      var map = m.map
      return map.domain.contains(n) ==> {
        let oldCount = map.count
        map.remove(domain: n)
        return map.count == (oldCount-1)
      }
    }
    
    property("the domain and range keys no longer map to each other") <- forAll {
      (m: ArbitraryInjectiveMap<Int,Float>, n: Int) in
      var map = m.map
      return map.domain.contains(n) ==> {
        let f = map.domainDictionary[n]!
        map.remove(domain: n)
        return
          (map.domainDictionary[n] == nil) <?> "domain doesn't map to the range"
            ^&&^ (map.rangeDictionary[f] == nil) <?> "range doesn't map to the domain"
      }
    }
    
    property("removal only affects the thing being removed") <- forAll {
      (m: ArbitraryInjectiveMap<Int,Float>, n: Int) in
      var map = m.map
      return map.domain.contains(n) ==> {
        var oldDict = map.domainDictionary
        map.remove(domain: n)
        oldDict[n] = nil
        return map.domainDictionary == oldDict
      }
    }
    
    property("removing something not in the map has no effect") <- forAll {
      (m: ArbitraryInjectiveMap<Int,String>, n: Int) in
      var map = m.map
      return !map.domain.contains(n) ==> {
        let oldMap = map
        map.remove(domain: n)
        return map == oldMap
      }
    }
  }
  
  func testRemove_range() {
    property("count decreases by one") <- forAll {
      (m: ArbitraryInjectiveMap<Float,Int>, n: Int) in
      var map = m.map
      return map.range.contains(n) ==> {
        let oldCount = map.count
        map.remove(range: n)
        return map.count == (oldCount-1)
      }
    }
    
    property("the domain and range keys no longer map to each other") <- forAll {
      (m: ArbitraryInjectiveMap<Float,Int>, n: Int) in
      var map = m.map
      return map.range.contains(n) ==> {
        let f = map.rangeDictionary[n]!
        map.remove(range: n)
        return
          (map.rangeDictionary[n] == nil) <?> "domain doesn't map to the range"
            ^&&^ (map.domainDictionary[f] == nil) <?> "range doesn't map to the domain"
      }
    }
    
    property("removal only affects the thing being removed") <- forAll {
      (m: ArbitraryInjectiveMap<Float,Int>, n: Int) in
      var map = m.map
      return map.range.contains(n) ==> {
        var oldDict = map.rangeDictionary
        map.remove(range: n)
        oldDict[n] = nil
        return map.rangeDictionary == oldDict
      }
    }
    
    property("removing something not in the map has no effect") <- forAll {
      (m: ArbitraryInjectiveMap<Int,String>, s: String) in
      var map = m.map
      return !map.range.contains(s) ==> {
        let oldMap = map
        map.remove(range: s)
        return map == oldMap
      }
    }
  }
  
  func testEquatable() {
    XCTFail() // FIXME: property("things are equal to themselves")
    
    XCTFail() // FIXME: property("things whose domain differs aren't equal")
    
    XCTFail() // FIXME: property("things whose range differs aren't equal")
  }
  
  func testSubscriptGet() {
    property("all domain subscripts work") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>) in
      let map = m.map
      let dict = m.dict
      let domain = map.domain
      
      return domain.reduce(true){
        (acc: Bool, key: String) in
        let value = dict[key]!
        return acc && (map[key] == value)
      }
    }
    
    property("all range subscripts work") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>) in
      let map = m.map
      let dict = m.backwards
      let range = map.range
      
      return range.reduce(true){
        (acc: Bool, key: Int) in
        let value = dict[key]!
        return acc && (map[key] == value)
      }
    }
    
    property("values not in the domain don't map") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>, s: String) in
      let map = m.map
      
      return !map.domain.contains(s) ==> {
        return map[s] == nil
      }
    }
    
    property("values not in the range don't map") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>, n: Int) in
      let map = m.map
      
      return !map.range.contains(n) ==> {
        return map[n] == nil
      }
    }
  }
  
  func testSubscriptSet_unique() {
    property("count increases by one") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>, s: String, n: Int) in
      var map1 = m.map
      var map2 = m.map
      
      return ((m.map[s] == nil) && (m.map[n] == nil)) ==> {
        let newCount = m.map.count + 1
        map1[s] = n
        map2[n] = s
        return
          (map1.count == newCount) <?> "domain"
            ^&&^ (map2.count == newCount) <?> "range"
      }
    }
    
    property("new values stick") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>, s: String, n: Int) in
      var map1 = m.map
      var map2 = m.map
      
      return ((m.map[s] == nil) && (m.map[n] == nil)) ==> {
        map1[s] = n
        map2[n] = s
        return (map1[s] == n) <?> "domain"
          ^&&^ (map2[n] == s) <?> "range"
      }
    }
    
    property("new values map back") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>, s: String, n: Int) in
      var map1 = m.map
      var map2 = m.map
      
      return ((m.map[s] == nil) && (m.map[n] == nil)) ==> {
        map1[s] = n
        map2[n] = s
        return (map1[n] == s) <?> "domain"
          ^&&^ (map2[s] == n) <?> "range"
      }
    }
  }
  
  func testSubscript_overwrite_both_domain() {
    property("equality isn't affected") <- forAll {
      (m: ArbitraryInjectiveMap<Int,String>, n: Int) in
      var map = m.map
      return map.domain.contains(n) ==> {
        let oldMap = map
        map[n] = map[n]
        return map == oldMap
      }
    }
  }
  
  func testSubscript_overwrite_both_range() {
    property("equality isn't affected") <- forAll {
      (m: ArbitraryInjectiveMap<String,Int>, n: Int) in
      var map = m.map
      return map.range.contains(n) ==> {
        let oldMap = map
        map[n] = map[n]
        return map == oldMap
      }
    }
  }
  
  func testSubscript_overwrite_domain() {
    XCTFail() // FIXME: property("count stays the same")
    
    XCTFail() // FIXME: property("change from domain subscript")
    
    XCTFail() // FIXME: property("change from domain subscript")
  }
  
  func testSubscript_overwrite_range() {
    XCTFail() // FIXME: property("count stays the same")
    
    XCTFail() // FIXME: property("change from range subscript")
    
    XCTFail() // FIXME: property("change from range subscript")
  }
  
  func testSubscriptSet_domainCollision_fromDomain() {
    XCTFail() // FIXME: property("insertion fails")
  }
  
  func testSubscriptSet_domainCollision_fromRange() {
    property("insertion fails") <- forAll {
      (m: ArbitraryInjectiveMap<Int,Character>, n: Int, c: Character) in
      var map = m.map
      return map.domain.contains(n) ==> {
        return map.range.contains(c) ==> {
          return (map[c] != n) ==> {
            let oldMap = map
            map[c] = n
            return map == oldMap
          }
        }
      }
    }
  }
  
  func testSubscriptSet_rangeCollision_fromDomain() {
    XCTFail() // FIXME: property("insertion fails")
  }
  
  func testSubscriptSet_rangeCollision_fromRange() {
    XCTFail() // FIXME: property("insertion fails")
  }
  
  func testSubscriptSet_nil_domain() {
    property("removing an item and setting it to nil has the same effect") <- forAll {
      (m: ArbitraryInjectiveMap<Int8,UInt16>, n: Int8) in
      let map = m.map
      return m.map.domain.contains(n) ==> {
        var removedMap = map
        var nilledMap = map
        removedMap.remove(domain: n)
        nilledMap[n] = nil
        return removedMap == nilledMap
      }
    }
  }
  
  func testSubscriptSet_nil_range() {
    property("removing an item and setting it to nil has the same effect") <- forAll {
      (m: ArbitraryInjectiveMap<Int8,UInt16>, n: UInt16) in
      let map = m.map
      return m.map.range.contains(n) ==> {
        var removedMap = map
        var nilledMap = map
        removedMap.remove(range: n)
        nilledMap[n] = nil
        return removedMap == nilledMap
      }
    }
  }
}

struct ArbitraryInjectiveMap<Domain: Hashable & Arbitrary, Range: Hashable & Arbitrary>: Arbitrary {
  let map: InjectiveMap<Domain,Range>
  let dict: Dictionary<Domain,Range>
  let backwards: Dictionary<Range,Domain>
  let hasGarbage: Bool
  
  private init(_ dict: UniqueDictionary<Domain,Range>) {
    let map = InjectiveMap<Domain,Range>(dict.dictionary)!
    self.map = map
    self.dict = dict.dictionary
    self.backwards = dict.backwards
    self.hasGarbage = false
  }
  
  private init(_ map: InjectiveMap<Domain,Range>) {
    self.map = map
    self.dict = map.domainDictionary
    self.backwards = map.rangeDictionary
    self.hasGarbage = map.garbageCount != 0
  }
  
  static var arbitrary: Gen<ArbitraryInjectiveMap<Domain, Range>> {
    return Gen<ArbitraryInjectiveMap<Domain,Range>>.compose{ c in
      let dict: UniqueDictionary<Domain,Range> = c.generate()
      
      // determine if we are generating a map that has garbage
      let hasGarbage: Bool = c.generate()
      
      if hasGarbage {
        // our map
        var map = InjectiveMap(dict.dictionary)!
        // determine how much garbage we wish to have
        let garbage: Int = c.generate(using:Gen<Int>.fromElements(in: 0...dict.dictionary.count))
        
        let keyGen = Gen<Domain>.fromElements(of: Array(map.domain))
        
        // remove `garbageCount` keys.
        for key in c.generate(using: keyGen.proliferate(withSize: garbage)) {
          map.remove(domain: key)
        }
        
        let pairGen = Gen<(Domain,Range)>.zip(Domain.arbitrary, Range.arbitrary)
        
        // add the same amount of keys so that the size is the same
        for (k,v) in c.generate(using: pairGen.proliferate(withSize: garbage)) {
          map[k] = v
        }
        
        // return the arbitrary map
        return ArbitraryInjectiveMap(map)
      } else {
        // otherwise just return a map
        return ArbitraryInjectiveMap(dict)
      }
    }
  }
}
