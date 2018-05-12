//
//  AppDelegate.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/17/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    private let userDefaults = UserDefaults.standard
    private let notificationCenter = NotificationCenter.default

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        setupAppearance()
        notificationCenter.addObserver(self, selector: #selector(setupAppearance), name: .themeUpdated, object: nil)
        return true
    }

    @objc private func setupAppearance() {
        let navBar = UINavigationBar.appearance()
        let refreshControl = UIRefreshControl.appearance()
        let activityIndicator = UIActivityIndicatorView.appearance()

        navBar.isTranslucent = false
        navBar.barStyle = .black
        navBar.tintColor = .white

        Theme.shared.styleNavbar(navBar)
        Theme.shared.styleUIRefreshControl(refreshControl)
        Theme.shared.styleUIActivityIndicator(activityIndicator)
    }
}
