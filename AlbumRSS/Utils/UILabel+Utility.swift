//
//  UILabel+Utility.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/14/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

extension UILabel {
  // a simplistic style common to all the UILabels in the app
  func configureStyle(fontSize: CGFloat = 13, textColor: UIColor = .black) {
    numberOfLines = 0
    lineBreakMode = .byTruncatingTail
    font = UIFont(name: "HelveticaNeue", size: fontSize)
    self.textColor = textColor
    textAlignment = .left
    translatesAutoresizingMaskIntoConstraints = false
  }
}
