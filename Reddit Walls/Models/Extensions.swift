//
//  Extensions.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/31/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    class var hintOfGray: UIColor {
        return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }

    class var redditBlue: UIColor {
        return UIColor(red: 38/255, green: 130/255, blue: 211/255, alpha: 1)
    }

    static let darkBlack = UIColor(red: 0.13, green: 0.13, blue: 0.13, alpha: 1.0)
    
    static let lightBlack = UIColor(red:0.16, green:0.16, blue:0.16, alpha: 1.0)
}

extension UIView {
    func centerInParentView() {
        guard let parentView = self.superview else { return }

        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
    }

    func fillSuperView() {
        if let superView = self.superview {
            self.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                self.leftAnchor.constraint(equalTo: superView.leftAnchor),
                self.rightAnchor.constraint(equalTo: superView.rightAnchor),
                self.topAnchor.constraint(equalTo: superView.topAnchor),
                self.bottomAnchor.constraint(equalTo: superView.bottomAnchor)
                ])
        }
    }

    func fadeIn(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = 1
        }
    }

    func fadeOut(duration: TimeInterval) {
        UIView.animate(withDuration: duration) {
            self.alpha = 0
        }
    }
}

extension Notification.Name {
    static let favoritesUpdated = Notification.Name(rawValue: "favoritesUpdated")
    static let themeUpdated = Notification.Name(rawValue: "themeUpdated")
}

extension UIStoryboard {
    // Segues
    static let favoritesSegue = "Favorites"

    // VC
    static let selectedWallpaperVC = UIStoryboard(name: "SelectedWallpaper", bundle: nil).instantiateInitialViewController() as! SelectedWallpaperVC

    class func wallpapersVC() -> WallpapersVC {
        let wallpapersVC = UIStoryboard(name: "WallpapersVC", bundle: nil).instantiateInitialViewController() as! WallpapersVC
        
        return wallpapersVC
    }
}

extension UserDefaults {
    static let themeKey = "theme"
}

extension URL {
    init(staticString: String) {
        self.init(string: "\(staticString)")!
    }
}
