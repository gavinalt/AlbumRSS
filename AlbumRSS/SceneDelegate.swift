//
//  SceneDelegate.swift
//  AlbumRSS
//
//  Created by Gavin Li on 8/11/20.
//  Copyright © 2020 Gavin Li. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  var window: UIWindow?

  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
    // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
    // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).

    guard let winScene = (scene as? UIWindowScene) else { return }
    let viewModel = AlbumListViewModel.init()
    let rootVC = AlbumListViewController(viewModel: viewModel, delegate: viewModel)
    window = UIWindow(windowScene: winScene)
    window?.rootViewController = UINavigationController(rootViewController: rootVC)
    window?.makeKeyAndVisible()
  }
}
