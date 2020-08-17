//
//  Album.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/11/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

struct Album: Codable {
  let id: String
  let name: String
  let artistId: String
  let artistName: String
  let artworkUrl: String

  let genres: [Genre]
  let releaseDate: String?
  let copyright: String?
  let storePageUrl: String

  enum CodingKeys: String, CodingKey {
    case id
    case name
    case artistId
    case artistName
    case artworkUrl = "artworkUrl100"

    case genres
    case releaseDate
    case copyright
    case storePageUrl = "url"
  }
}

struct Genre: Codable {
  let genreId: String
  let name: String
  let url: String
}
