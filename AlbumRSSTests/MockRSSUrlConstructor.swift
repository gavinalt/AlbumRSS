//
//  MockRSSUrlConstructor.swift
//  AlbumRSSTests
//
//  Created by Gavin Li on 8/16/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation
@testable import AlbumRSS

class MockRSSUrlConstructor: UrlConstructorProtocol {
  private let mockFile = "mockRSS"

  func rssFeedUrl() -> URL? {
    let bundle = Bundle(for: MockRSSUrlConstructor.self)
    guard let path = bundle.path(forResource: mockFile, ofType: "json") else {
      fatalError("Invalid URL")
    }
    let url = URL(fileURLWithPath: path)
    return url
  }

  func rssFeedUrlString() -> String {
    mockFile
  }
}
