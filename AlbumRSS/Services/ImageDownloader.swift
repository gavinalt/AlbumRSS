//
//  ImageDownloader.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/12/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

final class ImageDownloader {
  private let session: URLSession
  private let cache: LocalCache<URL, Data>

  private let mutex: DispatchQueue
  private var downloadInProgress = Set<URL>()

  init() {
    cache = LocalCache()
    session = URLSession(configuration: .default)
    // make sure there are no duplicate download tasks
    mutex = DispatchQueue(label: "ImageDownloaderCriticalSection", qos: .utility, attributes: .concurrent)
  }

  func download(from urlString: String, completion: @escaping (Data?) -> Void) {
    guard let url = URL(string: urlString) else { return completion(nil) }
    download(from: url, completion: completion)
  }

  func download(from url: URL, completion: @escaping (Data?) -> Void) {
    if let cachedData = cache[url] {
      return completion(cachedData)
    }

    mutex.sync(flags: .barrier) {
      if downloadInProgress.contains(url) {
        completion(nil)
        return
      } else {
        downloadInProgress.insert(url)
      }
    }

    let task = session.dataTask(with: url) { (data, _, _) in
      guard let data = data else {
        return completion(nil)
      }
      self.cache[url] = data

      _ = self.mutex.sync(flags: .barrier) {
        self.downloadInProgress.remove(url)
      }

      completion(data)
    }
    task.resume()
  }
}
