//
//  AlbumRSSTests.swift
//  AlbumRSSTests
//
//  Created by Gavin Li on 8/11/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import XCTest
@testable import AlbumRSS

class AlbumRSSTests: XCTestCase {
  func mockData(for fileName: String) throws -> Data {
    let bundle = Bundle(for: AlbumRSSTests.self)
    guard let path = bundle.path(forResource: fileName, ofType: "json") else {
      fatalError("\(fileName).json not found during testing")
    }
    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)
    return data
  }

  func testParsingAlbums() throws {
    let data = try mockData(for: "mockRSS")

    let networker = Networker()
    let expt = expectation(description: "Correctly parsed albums")
    var result: Result<Results, NetworkError>?
    networker.parseJSON(type: Results.self, data: data) {
      result = $0
      expt.fulfill()
    }
    wait(for: [expt], timeout: 3)

    let albums = try result?.get()
    XCTAssertEqual(albums?.results.count, 100)
    XCTAssertEqual(albums?.results[0].name, "Rich Slave")
    XCTAssertEqual(albums?.results[0].artistName, "Young Dolph")
    XCTAssertEqual(albums?.results[0].releaseDate, "2020-08-14")
    XCTAssertEqual(albums?.results[0].artworkUrl, "https://is1-ssl.mzstatic.com/image/thumb/Music124/v4/f4/67/7e/f4677ee9-2cc6-7c42-d47d-0332467bf248/194690167119_cover.jpg/200x200bb.png")
  }

  func testAlbumListViewModelFetchData() throws {
    let albumListViewModel = AlbumListViewModel.init(netWorker: MockNetworker(),
                                                     urlConstructor: MockRSSUrlConstructor())
    let expt = expectation(description: "Correctly fetched album list")
    albumListViewModel.bind {
      expt.fulfill()
    }
    albumListViewModel.fetchData()
    let waitResult = XCTWaiter.wait(for: [expt], timeout: 3)
    albumListViewModel.unbind()
    XCTAssertEqual(waitResult, .completed)

    XCTAssertEqual(albumListViewModel.numOfAlbums(in: 0), 100)
    XCTAssertEqual(albumListViewModel.albumName(for: IndexPath.init(row: 1, section: 0)), "Pray 4 Love (Deluxe)")
    XCTAssertEqual(albumListViewModel.albumArtist(for: IndexPath.init(row: 1, section: 0)), "Rod Wave")
    XCTAssertEqual(albumListViewModel.sectionCount, 1)
  }

  func testAlbumViewModel() throws {
    let data = try mockData(for: "mockAlbum")

    let networker = Networker()
    let expt = expectation(description: "Correctly parsed album")
    var result: Result<Album, NetworkError>?
    networker.parseJSON(type: Album.self, data: data) {
      result = $0
      expt.fulfill()
    }
    wait(for: [expt], timeout: 3)

    let album = try XCTUnwrap(result?.get())
    let albumViewModel = AlbumViewModel.init(album: album)
    XCTAssertEqual(albumViewModel.name, "Shoot for the Stars Aim for the Moon")
    XCTAssertEqual(albumViewModel.artist, "Pop Smoke")
    XCTAssertEqual(albumViewModel.releaseDataString, "2020-07-03")
    XCTAssertEqual(albumViewModel.copyright, "Victor Victor Worldwide; ℗ 2020 Republic Records, a division of UMG Recordings, Inc. & Victor Victor Worldwide")
    XCTAssertEqual(albumViewModel.genres, ["Hip-Hop/Rap", "Music"])
    XCTAssertEqual(albumViewModel.storePageUrlString, "https://music.apple.com/us/album/shoot-for-the-stars-aim-for-the-moon/1521889004?app=music")
  }

  func testParsingDamagedAlbum() throws {
    let data = try mockData(for: "mockAlbumDamaged")

    let networker = Networker()
    let expt = expectation(description: "Correctly parsed album")
    var result: Result<Album, NetworkError>?
    networker.parseJSON(type: Album.self, data: data) {
      result = $0
      expt.fulfill()
    }
    wait(for: [expt], timeout: 3)

    let album = try result?.get()
    XCTAssertEqual(album?.name, "Shoot for the Stars Aim for the Moon")
    XCTAssertEqual(album?.artistName, "Pop Smoke")
  }
}
