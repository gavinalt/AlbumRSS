//
//  UIView+Utility.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/11/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

extension UIView {
  // convenience method for filling a child view inside a parent view
  open func fill(in view: UIView) {
    translatesAutoresizingMaskIntoConstraints = false
    view.addSubview(self)
    let constraints = [
      leadingAnchor.constraint(equalTo: view.leadingAnchor),
      trailingAnchor.constraint(equalTo: view.trailingAnchor),
      topAnchor.constraint(equalTo: view.topAnchor),
      bottomAnchor.constraint(equalTo: view.bottomAnchor),
    ]
    NSLayoutConstraint.activate(constraints)
  }
}
