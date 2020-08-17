//
//  MockNetworker.swift
//  AlbumRSSTests
//
//  Created by Gavin Li on 8/16/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation
@testable import AlbumRSS

class MockNetworker: NetworkerProtocol {
  func loadJSONData<T: Decodable>(type: T.Type,
                                  url: String,
                                  params: [String: String]?,
                                  completion: @escaping (Result<T, NetworkError>) -> Void) {
    guard let path = Bundle(for: MockNetworker.self).path(forResource: url, ofType: "json") else {
      completion(.failure(.invalidURL))
      return
    }
    let url = URL(fileURLWithPath: path)
    loadJSONData(type: type, url: url, params: params, completion: completion)
  }

  func loadJSONData<T: Decodable>(type: T.Type,
                                  url: URL,
                                  params: [String: String]?,
                                  completion: @escaping (Result<T, NetworkError>) -> Void) {
    let data: Data
    do {
      data = try Data(contentsOf: url)
      let decoder = JSONDecoder()
      let typedObject: T = try decoder.decode(T.self, from: data)
      completion(.success(typedObject))
    } catch let error as DecodingError {
      completion(.failure(.parseError(error)))
    } catch {
      completion(.failure(.invalidURL))
    }
  }
}

