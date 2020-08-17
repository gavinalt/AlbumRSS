//
//  UIViewController+Alert.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/15/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

extension UIViewController {
  // present an alert with a confirm button
  public func showAlert(title: String, message: String? = nil) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
    alert.addAction(defaultAction)
    self.present(alert, animated: true, completion: nil)
  }
}
