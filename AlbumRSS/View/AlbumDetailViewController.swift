//
//  AlbumDetailViewController.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/16/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

// MARK: - AlbumDetialViewModelProtocol
protocol AlbumDetialViewModelProtocol {
  func bind(_ infoUpdateHandler: @escaping () -> Void)
  func unbind()

  var name: String { get }
  var artist: String { get }
  func image(completion: @escaping (Data?) -> Void)
  func largerImage(completion: @escaping (Data?) -> Void)
  var genres: [String] { get }
  var releaseDataString: String? { get }
  var copyright: String? { get }
  var storePageUrlString: String { get }
  var storePageUrl: URL? { get }
}

// MARK: - AlbumDetailViewController
class AlbumDetailViewController: UIViewController {
  private var viewModel: AlbumDetialViewModelProtocol

  private let largerImage: UIImageView = UIImageView.init(frame: .zero)
  private let detailedInfoStack: UIStackView = {
    let view = UIStackView.init(frame: .zero)
    view.axis = .vertical
    view.spacing = 4
    view.distribution = .equalSpacing
    view.alignment = .leading
    view.isLayoutMarginsRelativeArrangement = true
    view.layoutMargins = UIEdgeInsets(top: 4, left: 8, bottom: 4, right: 8)
    view.setContentHuggingPriority(.required, for: .horizontal)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  private let albumPageButton: UIButton = UIButton.init(frame: .zero)

  // constraints for portrait orientation
  private var regularHeightConstraints: [NSLayoutConstraint] = []
  // constraints for landscape orientation
  private var compactHeightConstraints: [NSLayoutConstraint] = []

  init(viewModel: AlbumDetialViewModelProtocol) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    title = viewModel.name
    view.backgroundColor = .systemBackground
    setUpConstraints()
    setUpAlbumImage()
    setUpDetailedInfoStack()
    setUpAlbumPageButton()

    toggleConstraints()
  }

  override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
    super.traitCollectionDidChange(previousTraitCollection)
    if previousTraitCollection?.verticalSizeClass != traitCollection.verticalSizeClass {
      toggleConstraints()
    }
  }

  private func setUpConstraints() {
    view.addSubview(largerImage)
    view.addSubview(detailedInfoStack)
    view.addSubview(albumPageButton)

    let guide: UILayoutGuide
    if #available(iOS 11.0, *) {
      guide = view.safeAreaLayoutGuide
    } else {
      guide = view.layoutMarginsGuide
    }
    regularHeightConstraints = [
      largerImage.centerXAnchor.constraint(equalTo: guide.centerXAnchor),

      detailedInfoStack.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      detailedInfoStack.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 8),
      detailedInfoStack.topAnchor.constraint(equalTo: largerImage.bottomAnchor, constant: 8),

      albumPageButton.centerXAnchor.constraint(equalTo: guide.centerXAnchor),
      albumPageButton.topAnchor.constraint(greaterThanOrEqualTo: detailedInfoStack.bottomAnchor, constant: 8),
      albumPageButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 20)
    ]
    compactHeightConstraints = [
      largerImage.centerYAnchor.constraint(equalTo: guide.centerYAnchor),

      detailedInfoStack.leadingAnchor.constraint(equalTo: largerImage.trailingAnchor, constant: 8),
      detailedInfoStack.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
      detailedInfoStack.trailingAnchor.constraint(equalTo: guide.trailingAnchor, constant: -16),

      albumPageButton.topAnchor.constraint(greaterThanOrEqualTo: detailedInfoStack.bottomAnchor, constant: 8),
      albumPageButton.leadingAnchor.constraint(equalTo: detailedInfoStack.leadingAnchor),
      albumPageButton.trailingAnchor.constraint(equalTo: detailedInfoStack.trailingAnchor)
    ]

    // common constraints in both orientations
    let albumAspect = largerImage.widthAnchor.constraint(equalTo: largerImage.heightAnchor)
    albumAspect.priority = .defaultHigh
    NSLayoutConstraint.activate([
      albumAspect,
      largerImage.topAnchor.constraint(equalTo: guide.topAnchor, constant: 16),
      largerImage.leadingAnchor.constraint(equalTo: guide.leadingAnchor, constant: 16),
      albumPageButton.bottomAnchor.constraint(equalTo: guide.bottomAnchor, constant: -20)
    ])
  }

  func toggleConstraints() {
    switch traitCollection.verticalSizeClass {
    case .regular:
      NSLayoutConstraint.deactivate(compactHeightConstraints)
      NSLayoutConstraint.activate(regularHeightConstraints)
    case .compact:
      NSLayoutConstraint.deactivate(regularHeightConstraints)
      NSLayoutConstraint.activate(compactHeightConstraints)
    default:
      print("unknown vertical size class: \(traitCollection.verticalSizeClass)")
    }
  }

  private func setUpAlbumImage() {
    largerImage.translatesAutoresizingMaskIntoConstraints = false
    largerImage.layer.cornerRadius = 8
    largerImage.clipsToBounds = true
    viewModel.largerImage { [weak self] imageData in
      DispatchQueue.main.async {
        if let imageData = imageData {
          self?.largerImage.image = UIImage.init(data: imageData)
        } else {
          self?.largerImage.image = UIImage.init(named: "placeholder")
        }
      }
    }
  }

  private func setUpDetailedInfoStack() {
    let name = UILabel.init(frame: .zero),
    artist = UILabel.init(frame: .zero),
    genre = UILabel.init(frame: .zero),
    releaseDate = UILabel.init(frame: .zero),
    copyright = UILabel.init(frame: .zero)

    name.configureStyle()
    artist.configureStyle()
    genre.configureStyle()
    releaseDate.configureStyle()
    copyright.configureStyle()

    name.text = "Album Name: \(viewModel.name)"
    artist.text = "Artist: \(viewModel.artist)"
    genre.text = "Genres: \(viewModel.genres.joined(separator: "; "))"
    releaseDate.text = "Release Date: \(viewModel.releaseDataString ?? "")"
    copyright.text = "Copyright: \(viewModel.copyright ?? "")"

    detailedInfoStack.addArrangedSubview(name)
    detailedInfoStack.addArrangedSubview(artist)
    detailedInfoStack.addArrangedSubview(genre)
    detailedInfoStack.addArrangedSubview(releaseDate)
    detailedInfoStack.addArrangedSubview(copyright)
  }

  private func setUpAlbumPageButton() {
    albumPageButton.translatesAutoresizingMaskIntoConstraints = false
    albumPageButton.backgroundColor = .systemBlue
    albumPageButton.layer.cornerRadius = 8
    albumPageButton.setTitle("View in iTunes", for: .normal)
    albumPageButton.addTarget(self, action: #selector(openInItunes), for: .touchUpInside)
  }

  @objc func openInItunes(sender: UIButton!) {
    guard let itunesUrl = viewModel.storePageUrl else { return }
    // open the album either in iTunes or Safari
    if UIApplication.shared.canOpenURL(itunesUrl) {
      UIApplication.shared.open(itunesUrl, options: [:], completionHandler: nil)
    } else if let httpsUrl = URL.init(string: viewModel.storePageUrlString) {
      UIApplication.shared.open(httpsUrl, options: [:], completionHandler: nil)
    }
  }
}
