//
//  AlbumListViewModel.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/11/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import Foundation

class AlbumListViewModel: AlbumListViewModelProtocol {
  private let netWorker: NetworkerProtocol
  private let imageDownloader: ImageDownloader
  private let urlConstructor: UrlConstructorProtocol

  private var listUpdateHandler: (() -> Void)?
  private var listUpdateFailureHandler: ((Error) -> Void)?

  private var albums: [AlbumViewModel] = [] {
    didSet { listUpdateHandler?() }
  }

  init(netWorker: NetworkerProtocol = Networker(),
       imageDownloader: ImageDownloader = ImageDownloader(),
       urlConstructor: UrlConstructorProtocol = RSSUrlConstructor()) {
    self.netWorker = netWorker
    self.imageDownloader = imageDownloader
    self.urlConstructor = urlConstructor
  }

  @discardableResult
  func bind(onSuccess listUpdateHandler: @escaping () -> Void) -> Self {
    self.listUpdateHandler = listUpdateHandler
    return self
  }

  @discardableResult
  func bind(onFailure listUpdateFailureHandler: @escaping (Error) -> Void) -> Self {
    self.listUpdateFailureHandler = listUpdateFailureHandler
    return self
  }

  func unbind() {
    listUpdateHandler = nil
    listUpdateFailureHandler = nil
  }

  func fetchData() {
    netWorker.loadJSONData(type: Results.self, url: urlConstructor.rssFeedUrlString(), params: nil) {
      result in
      switch result {
      case let .success(resultsContainer):
        self.albums = self.albumViewModels(from: resultsContainer.results)
      case let .failure(error):
        self.listUpdateFailureHandler?(error)
      }
    }
  }

  private func albumViewModels(from albums: [Album]) -> [AlbumViewModel] {
    albums.map {
      AlbumViewModel.init(album: $0, imageDownloader: imageDownloader, urlConstructor: urlConstructor)
    }
  }
}

extension AlbumListViewModel {
  var sectionCount: Int {
    1
  }

  func numOfAlbums(in section: Int) -> Int {
    albums.count
  }

  func albumViewModel(for indexPath: IndexPath) -> AlbumViewModel {
    albums[indexPath.row]
  }

  func albumName(for indexPath: IndexPath) -> String {
    albums[indexPath.row].name
  }

  func albumArtist(for indexPath: IndexPath) -> String {
    albums[indexPath.row].artist
  }

  func image(for indexPath: IndexPath, completion: @escaping (Data?) -> Void) {
    albums[indexPath.row].image(completion: completion)
  }
}

extension AlbumListViewModel: AlbumListDelegateProtocol {
  func didSelectAlbum(_ viewController: AlbumListViewController, at indexPath: IndexPath) {
    let albumDetailViewController = AlbumDetailViewController.init(viewModel: albumViewModel(for: indexPath))
    viewController.navigationController?.pushViewController(albumDetailViewController, animated: true)
  }
}
