//
//  AlbumViewModel.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/13/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

class AlbumViewModel: AlbumDetialViewModelProtocol {
  private let imageDownloader: ImageDownloader
  private let urlConstructor: UrlConstructorProtocol

  private var infoUpdateHandler: (() -> Void)?

  private var album: Album {
    didSet { infoUpdateHandler?() }
  }

  init(album: Album,
       imageDownloader: ImageDownloader = ImageDownloader(),
       urlConstructor: UrlConstructorProtocol = RSSUrlConstructor()) {
    self.album = album
    self.imageDownloader = imageDownloader
    self.urlConstructor = urlConstructor
  }

  func bind(_ infoUpdateHandler: @escaping () -> Void) {
    self.infoUpdateHandler = infoUpdateHandler
  }

  func unbind() {
    infoUpdateHandler = nil
  }

  private func largerImageUrl(desiredSize: Int) -> URL? {
    guard let imageUrl200 = URL(string: album.artworkUrl) else {
      return nil
    }
    let newSizeComponent = "\(desiredSize)x\(desiredSize)bb.png"

    return imageUrl200.deletingLastPathComponent().appendingPathComponent(newSizeComponent)
  }
}

extension AlbumViewModel {
  var name: String {
    album.name
  }

  var artist: String {
    album.artistName
  }

  func image(completion: @escaping (Data?) -> Void) {
    imageDownloader.download(from: album.artworkUrl, completion: completion)
  }

  func largerImage(completion: @escaping (Data?) -> Void) {
    guard let largerImageUrl = largerImageUrl(desiredSize: 500) else {
      completion(nil)
      return
    }
    imageDownloader.download(from: largerImageUrl, completion: completion)
  }

  var genres: [String] {
    album.genres.map { $0.name }
  }

  var releaseDataString: String? {
    album.releaseDate
  }

  var copyright: String? {
    album.copyright
  }

  var storePageUrlString: String {
    album.storePageUrl
  }

  var storePageUrl: URL? {
    guard var httpsUrl = URLComponents(string: album.storePageUrl) else {
      return nil
    }
    httpsUrl.scheme = "itms"
    return httpsUrl.url
  }
}
