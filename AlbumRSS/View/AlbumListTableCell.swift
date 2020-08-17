//
//  AlbumListTableCell.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/11/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class AlbumListTableCell: UITableViewCell {
  private var name: UILabel, artist: UILabel, artwork: UIImageView

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    name = UILabel.init(frame: .zero)
    artist = UILabel.init(frame: .zero)
    artwork = UIImageView.init(frame: .zero)

    super.init(style: .default, reuseIdentifier: reuseIdentifier)
    backgroundColor = .systemBackground
    setupSubview()
  }

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupSubview() {
    self.contentView.addSubview(name)
    self.contentView.addSubview(artist)
    self.contentView.addSubview(artwork)

    self.translatesAutoresizingMaskIntoConstraints = false
    name.configureStyle(fontSize: 15)
    artist.configureStyle(fontSize: 11, textColor: .secondaryLabel)
    artwork.translatesAutoresizingMaskIntoConstraints = false
    artwork.layer.cornerRadius = 4
    artwork.clipsToBounds = true

    NSLayoutConstraint.activate([
      artwork.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
      artwork.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
      artwork.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      artwork.widthAnchor.constraint(equalTo: artwork.heightAnchor),
      contentView.heightAnchor.constraint(equalToConstant: 64),

      name.leadingAnchor.constraint(equalTo: artwork.trailingAnchor, constant: 16),
      name.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -8),
      name.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),

      artist.topAnchor.constraint(greaterThanOrEqualTo: name.bottomAnchor, constant: 4),
      artist.leadingAnchor.constraint(equalTo: name.leadingAnchor),
      artist.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8)
    ])
    artwork.setContentCompressionResistancePriority(.required, for: .horizontal)
  }
}

extension AlbumListTableCell {
  func configureSelf(from albumViewModel: AlbumViewModel) {
    name.text = albumViewModel.name
    artist.text = albumViewModel.artist
    albumViewModel.image { [weak self] imageData in
      DispatchQueue.main.async {
        if let imageData = imageData {
          self?.artwork.image = UIImage.init(data: imageData)
        } else {
          self?.artwork.image = nil
        }
      }
    }
  }
}
