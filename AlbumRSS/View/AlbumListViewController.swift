//
//  AlbumListViewController.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/11/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

// MARK: - AlbumListViewModelProtocol
protocol AlbumListViewModelProtocol {
  @discardableResult func bind(onSuccess listUpdateHandler: @escaping () -> Void) -> Self
  @discardableResult func bind(onFailure listUpdateFailureHandler: @escaping (Error) -> Void) -> Self
  func unbind()
  func fetchData()

  var sectionCount: Int { get }
  func numOfAlbums(in section: Int) -> Int
  func albumViewModel(for indexPath: IndexPath) -> AlbumViewModel
  func albumName(for indexPath: IndexPath) -> String
  func albumArtist(for indexPath: IndexPath) -> String
}

// MARK: - AlbumListDelegateProtocol
protocol AlbumListDelegateProtocol: AnyObject {
  func didSelectAlbum(_ viewController: AlbumListViewController, at indexPath: IndexPath)
}

// MARK: - AlbumListViewController
class AlbumListViewController: UIViewController {
  private let albumListTableCellID = "albumListTableCellID"
  private let tableView: UITableView

  private let viewModel: AlbumListViewModelProtocol
  private let delegate: AlbumListDelegateProtocol?

  init(viewModel: AlbumListViewModelProtocol, delegate: AlbumListDelegateProtocol? = nil) {
    tableView = UITableView.init(frame: .zero)
    self.viewModel = viewModel
    self.delegate = delegate
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    setUpView()
    viewModel
      .bind(onSuccess: {
        DispatchQueue.main.async {
          self.tableView.reloadData()
        }
      })
      .bind(onFailure: { error in
        print(error)
        DispatchQueue.main.async {
          self.showAlert(title: "Error Gettting Albums", message: error.localizedDescription)
        }
      })
    
    viewModel.fetchData()
  }

  deinit {
    viewModel.unbind()
  }

  private func setUpView() {
    self.title = "Album RSS Feed"

    tableView.fill(in: self.view)
    tableView.register(AlbumListTableCell.self, forCellReuseIdentifier: albumListTableCellID)
    tableView.dataSource = self
    tableView.delegate = self
    tableView.estimatedRowHeight = 80
    tableView.rowHeight = UITableView.automaticDimension
  }
}

extension AlbumListViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    viewModel.sectionCount
  }

  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    viewModel.numOfAlbums(in: section)
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: AlbumListTableCell = {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: albumListTableCellID) as? AlbumListTableCell else {
        let albumListTableCell = AlbumListTableCell.init(style: .default, reuseIdentifier: albumListTableCellID)
        return albumListTableCell
      }
      return cell
    } ()
    cell.configureSelf(from: viewModel.albumViewModel(for: indexPath))
    return cell
  }
}

extension AlbumListViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: true)
    delegate?.didSelectAlbum(self, at: indexPath)
  }
}
