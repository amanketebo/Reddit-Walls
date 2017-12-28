//
//  AppDelegate.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/17/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool
    {
        setupAppearance()
        return true
    }
    
    private func setupAppearance()
    {
        let navBar = UINavigationBar.appearance()
        let refreshControl = UIRefreshControl.appearance()
        
        navBar.isTranslucent = false
        navBar.barStyle = .black
        navBar.tintColor = .white
        navBar.barTintColor = .redditBlue
        refreshControl.backgroundColor = .redditBlue
        refreshControl.tintColor = .white
    }
}

