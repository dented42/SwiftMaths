//
//  InjectiveMap.swift
//  SwiftMaths
//
//  Created by Matias Eyzaguirre on 9/7/17.
//  Copyright © 2017 Matias Eyzaguirre. All rights reserved.
//

import Foundation

public struct InjectiveMap<Domain: Hashable, Range: Hashable> {
  
  private var contents: [(Domain,Range)]
  
  private var domainMap: [Domain: Array<(Domain,Range)>.Index]
  private var rangeMap: [Range: Array<(Domain,Range)>.Index]
  
  public var domain: Set<Domain> {
    return Set(domainMap.keys)
  }
  
  public var range: Set<Range> {
    return Set(rangeMap.keys)
  }
  
  public var domainDictionary: Dictionary<Domain,Range> {
    return domainMap.mapValues{
      (idx: Array<(Domain,Range)>.Index) in
      let (_,r) = contents[idx]
      return r
    }
  }
  
  public var rangeDictionary: Dictionary<Range,Domain> {
    return rangeMap.mapValues{
      (idx: Array<(Domain,Range)>.Index) in
      let (d,_) = contents[idx]
      return d
    }
  }
  
  public init() {
    contents = []
    domainMap = [:]
    rangeMap = [:]
  }
  
  public init?(_ fDict: [Domain: Range]) {
    self.init()
    
    for (k,v) in fDict {
      // gMap musn't already contain they value
      guard !rangeMap.keys.contains(v) else {
        return nil
      }
      
      // insert the pair
      contents.append((k,v))
      
      // create the index mapping
      domainMap[k] = contents.count-1
      rangeMap[v] = contents.count-1
    }
  }
  
  public func contains(_ d: Domain, _ r: Range) -> Bool {
    guard let domainIndex = domainMap[d] else {
      return false
    }
    guard let rangeIndex = rangeMap[r] else {
      return false
    }
    return domainIndex == rangeIndex
  }
  
  public func contains(_ p: (Domain, Range)) -> Bool {
    let (d,r) = p
    return self.contains(d,r)
  }
  
  public mutating func compact(whenGarbagePasses garbageLimit: Int = 64,
                               shrinkStorage: Bool = false) {
    if garbageCount >= garbageLimit {
      // get a list of used indices
      var goodIdxs = Set(domainMap.values)
      
      // get a list of garbage indices
      var garbageIdxs: Set<Int> = Set(contents.indices).subtracting(goodIdxs)
      
//      // determine the indices of content that will be moved into the garbage holes
//      let movingIdxs = Array(domainMap.values).sorted().lazy.reversed()
      
      // keep removing garbage until there's none left
      while !garbageIdxs.isEmpty {
        let endIdx = contents.indices.last!
        // if the end isn't garbage then move some garbage into it
        if !garbageIdxs.contains(endIdx) {
          // the end kinda has to be in the goodIdxs or something went horribly wrong
          assert(goodIdxs.contains(endIdx))
          // find a garbage place to move the end to
          let garbageIdx = garbageIdxs.first!
          // get the stuff to move
          let (endD, endR) = contents[endIdx]
          // move it over
          contents[garbageIdx] = (endD, endR)
          // adjust references
          domainMap[endD] = garbageIdx
          rangeMap[endR] = garbageIdx
          // book keeping
          goodIdxs.insert(garbageIdx)
          goodIdxs.remove(endIdx)
          garbageIdxs.remove(garbageIdx)
          garbageIdxs.insert(endIdx)
        }
        // the thing at the end is garbage
        assert(garbageIdxs.contains(endIdx))
        // remove the thing at the end
        contents.remove(at: endIdx)
        garbageIdxs.remove(endIdx)
      }
    }
    if shrinkStorage {
      let oldContents = contents
      contents = Array(oldContents)
    }
  }
  
  public mutating func remove(domain: Domain) {
    if let range = self[domain] {
      domainMap.removeValue(forKey: domain)
      rangeMap.removeValue(forKey: range)
    }
  }
  
  public mutating func remove(range: Range) {
    if let domain = self[range] {
      domainMap.removeValue(forKey: domain)
      rangeMap.removeValue(forKey: range)
    }
  }
}

public extension InjectiveMap {
  public var count: Int {
    assert(domainMap.count == rangeMap.count)
    return domainMap.count
  }
  public var garbageCount: Int {
    return contents.count - count
  }
  public var storeCount: Int {
    return contents.count
  }
}

extension InjectiveMap: Equatable {
  public static func ==(lhs: InjectiveMap<Domain, Range>, rhs: InjectiveMap<Domain, Range>) -> Bool {
    return lhs.domainDictionary == rhs.domainDictionary
  }
}

public extension InjectiveMap {
  public subscript(input: Domain) -> Range? {
    get {
      // grab the index
      guard let index = domainMap[input] else {
        return nil
      }
      // get the value
      let (_, value) = contents[index]
      return value
    }
    set(v) {
      guard let value = v else {
        // remove the pair the domain currently maps to if setting to nil
        return remove(domain: input)
      }
      // we only do stuff when there's not a value collision
      if !rangeMap.keys.contains(value) {
        // if the input isn't in the domain.
        if !domainMap.keys.contains(input) {
          // add the pair
          contents.append((input,value))
          // get the last index
          let idx = contents.indices.last
          domainMap[input] = idx
          rangeMap[value] = idx
        } else {
          // if the input is in the domain then we can just overwrite the contents pair
          let idx = domainMap[input]!
          let (_, oldValue) = contents[idx]
          contents[idx] = (input, value)
          rangeMap[oldValue] = nil
          rangeMap[value] = idx
        }
      }
    }
  }
  
  public subscript(input: Range) -> Domain? {
    get {
      // grab the index
      guard let index = rangeMap[input] else {
        return nil
      }
      // get the value
      let (value, _) = contents[index]
      return value
    }
    set(v) {
      guard let value = v else {
        // remove the pair the domain currently maps to if setting to nil
        return remove(range: input)
      }
      // as long as there isn't a value collision
      if !domainMap.keys.contains(value) {
        // if the input isn't in the range.
        if !rangeMap.keys.contains(input) {
          // add the pair
          contents.append((value,input))
          // get the last index
          let idx = contents.indices.last
          domainMap[value] = idx
          rangeMap[input] = idx
        } else {
          // if the input is in the range then just overwrite the contents pair
          let idx = rangeMap[input]!
          let (oldValue, _) = contents[idx]
          contents[idx] = (value, input)
          domainMap[oldValue] = nil
          domainMap[value] = idx
        }
      }
    }
  }
}

//extension InjectiveMap: Collection {
//  typealias Element = (Domain,Range)
//
//
//  typealias Index = Array<(Domain,Range)>.Index
//
//  var startIndex: Index {
//    return contents.startIndex
//  }
//
//  var endIndex: Index {
//    return contents.endIndex
//  }
//
//  func index(after i: Index) -> Index {
//    return contents.index(after: i)
//  }
//
//  subscript(index: Domain) -> Range {
//    get {
//      let (_, value) = contents[(domainMap[index])!]
//      return value
//    }
//  }
//
//}

