//
//  Results.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/13/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

struct Results: Decodable {
  let results: [Album]

  enum JSONRootKeys: String, CodingKey {
    case feed
  }

  enum JSONFeedKeys: String, CodingKey {
    case results
  }

  // only need to work on the results directory inside feed
  // here is the structure of the json response { feed: { results: [Album] } }
  init(from decoder: Decoder) throws {
    let data = try decoder.container(keyedBy: JSONRootKeys.self)
    let feedData = try data.nestedContainer(keyedBy: JSONFeedKeys.self, forKey: .feed)
    results = try feedData.decode([Album].self, forKey: .results)
  }
}
