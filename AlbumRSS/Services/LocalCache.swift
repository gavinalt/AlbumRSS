//
//  LocalCache.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/12/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

final class LocalCache<KeyT: Hashable, ValueT> {
  private let nsCache = NSCache<WrappedKey, Entry>()

  init(maximumEntryCount: Int = 500) {
    nsCache.countLimit = maximumEntryCount
  }

  func insert(_ value: ValueT, forKey key: KeyT) {
    let entry = Entry(key: key, value: value)
    nsCache.setObject(entry, forKey: WrappedKey(key))
  }

  func value(forKey key: KeyT) -> ValueT? {
    let entry = nsCache.object(forKey: WrappedKey(key))
    return entry?.value
  }

  func removeValue(forKey key: KeyT) {
    nsCache.removeObject(forKey: WrappedKey(key))
  }

  subscript(key: KeyT) -> ValueT? {
    get { return value(forKey: key) }
    set {
      if let value = newValue {
        insert(value, forKey: key)
      } else {
        removeValue(forKey: key)
      }
    }
  }
}

private extension LocalCache {
  final class WrappedKey: NSObject {
    let key: KeyT
    init(_ key: KeyT) { self.key = key }

    override var hash: Int { return key.hashValue }

    override func isEqual(_ object: Any?) -> Bool {
      guard let value = object as? WrappedKey else { return false }
      return key == value.key
    }
  }

  final class Entry {
    let key: KeyT
    let value: ValueT

    init(key: KeyT, value: ValueT) {
      self.key = key
      self.value = value
    }
  }
}
