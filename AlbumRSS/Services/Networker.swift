//
//  Networker.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/12/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

enum NetworkError: Error {
  case invalidURL
  case noResponseMetadata
  case invalidResponseStatusCode(Int)
  case requestError(Error?)
  case parseError(Error?)
  case unknownError
}

protocol NetworkerProtocol {
  func loadJSONData<T: Decodable>(type: T.Type,
                                  url: String,
                                  params: [String: String]?,
                                  completion: @escaping (Result<T, NetworkError>) -> Void)
  func loadJSONData<T: Decodable>(type: T.Type,
                                  url: URL,
                                  params: [String: String]?,
                                  completion: @escaping (Result<T, NetworkError>) -> Void)
}

final class Networker: NetworkerProtocol {
  let urlSession: URLSession
  let decoder: JSONDecoder

  init() {
    urlSession = URLSession(configuration: .default)
    decoder = JSONDecoder()
  }

  init(_ session: URLSession, _ decoder: JSONDecoder) {
    urlSession = session
    self.decoder = decoder
  }

  func loadJSONData<T: Decodable>(type: T.Type,
                                  url: String,
                                  params: [String: String]?,
                                  completion: @escaping (Result<T, NetworkError>) -> Void) {
    guard let url = URL(string: url) else {
      completion(.failure(.invalidURL))
      return
    }
    loadJSONData(type: type, url: url, params: params, completion: completion)
  }

  func loadJSONData<T: Decodable>(type: T.Type,
                                  url: URL,
                                  params: [String: String]?,
                                  completion: @escaping (Result<T, NetworkError>) -> Void) {
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = params
    let dataTask = URLSession.shared.dataTask(with: request) { (data, response, error) in
      if let error = error {
        completion(.failure(.requestError(error)))
        return
      }

      guard let response = response as? HTTPURLResponse else {
        completion(.failure(.noResponseMetadata))
        return
      }

      guard 200 ..< 300 ~= response.statusCode else {
        completion(.failure(.invalidResponseStatusCode(response.statusCode)))
        return
      }

      guard let data = data else {
        completion(.failure(.requestError(error)))
        return
      }
      
      self.parseJSON(type: type, data: data, completion: completion)
    }
    dataTask.resume()
  }

  func parseJSON<T: Decodable>(type: T.Type, data: Data, completion: @escaping (Result<T, NetworkError>) -> Void) {
    do {
      let typedObject: T = try decoder.decode(T.self, from: data)
      completion(.success(typedObject))
    } catch let error {
      completion(.failure(.parseError(error)))
    }
  }
}
