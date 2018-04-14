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
}

extension Notification.Name {
    static let favoritesUpdated = Notification.Name(rawValue: "favoritesUpdated")
    static let themeUpdated = Notification.Name(rawValue: "themeUpdated")
}

extension UIStoryboard {
    // Storyboards
    static let selectedWallpaper = UIStoryboard(name: "SelectedWallpaper", bundle: nil)

    // Segues
    static let favoritesSegue = "Favorites"
}

extension UserDefaults {
    static let themeKey = "theme"
}
