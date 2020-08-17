//
//  RSSUrlConstructor.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/13/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

protocol UrlConstructorProtocol {
  func rssFeedUrlString() -> String
  func rssFeedUrl() -> URL?
}

class RSSUrlConstructor: UrlConstructorProtocol {
  // url constructed from this webpage: https://rss.itunes.apple.com/en-us
  private let feedUrl = "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/100/explicit.json"

  func rssFeedUrlString() -> String {
    feedUrl
  }

  func rssFeedUrl() -> URL? {
    URL.init(string: feedUrl)
  }
}
