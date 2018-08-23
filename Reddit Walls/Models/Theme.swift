//
//  Theme.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 2/18/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit

enum Mode: Int {
    case light
    case dark
}

class Theme {
    static let shared = Theme()

    let userDefaults = UserDefaults.standard

    var mode: Mode {
        let savedTheme = userDefaults.integer(forKey: UserDefaults.themeKey)

        if savedTheme == 0 {
            return .light
        } else {
            return .dark
        }
    }

    func styleNavbar(_ navbar: UINavigationBar?) {
        switch mode {
        case .light: navbar?.barTintColor = .redditBlue
        case .dark: navbar?.barTintColor = .lightBlack
        }
    }

    func styleBackground(_ view: UIView) {
        switch mode {
        case .light: view.backgroundColor = .white
        case .dark: view.backgroundColor = .darkBlack
        }
    }

    func styleCell(_ themeCell: ThemeCell) {
        styleBackground(themeCell.contentView)
        styleLabel(themeCell.darkLabel)
        styleSwitch(themeCell.darkSwitch)
    }

    func styleLabel(_ label: UILabel, favoritesScreen: Bool = false) {
        switch mode {
        case .light: label.textColor = favoritesScreen ? .gray : .black
        case .dark: label.textColor = .white
        }
    }

    func styleRedditViewsLabel(_ label: UILabel) {
        switch mode {
        case .light:
            label.backgroundColor = .white
            label.textColor = .black
        case .dark:
            label.backgroundColor = .darkBlack
            label.textColor = .white
        }
    }

    func styleSwitch(_ uiSwitch: UISwitch) {
        switch mode {
        case .light: uiSwitch.onTintColor = nil
        case .dark: uiSwitch.onTintColor = .redditBlue
        }
    }

    func favoriteIconImage(selected: Bool) -> UIImage {
        switch (mode, selected) {
        case (.light, true): return #imageLiteral(resourceName: "filledstar")
        case (.light, false): return #imageLiteral(resourceName: "unfilledblackstar")
        case (.dark, true): return #imageLiteral(resourceName: "filledbluestar")
        case (.dark, false): return #imageLiteral(resourceName: "unfilledbluestar")
        }
    }

    func styleWallpaperCell(_ wallpaperCell: WallpaperCell) {
        styleBackground(wallpaperCell.contentView)
        styleLabel(wallpaperCell.title)
        styleLabel(wallpaperCell.submittedByLabel)
        wallpaperCell.author.textColor = .redditBlue
        styleCellSeperator(seperatorView: wallpaperCell.seperator)
    }

    func styleLoadingCell(_ loadingCell: LoadingCell) {
        styleBackground(loadingCell.contentView)
    }

    func styleCellSeperator(seperatorView: UIView) {
        switch mode {
        case .light: seperatorView.backgroundColor = .lightGray
        case .dark: seperatorView.backgroundColor = .lightBlack
        }
    }

    func styleUIRefreshControl(_ refreshControl: UIRefreshControl) {
        switch mode {
        case .light: refreshControl.tintColor = .gray
        case .dark: refreshControl.tintColor = .white
        }
    }

    func styleUIActivityIndicator(_ activityIndicator: UIActivityIndicatorView) {
        switch mode {
        case .light: activityIndicator.color = .gray
        case .dark: activityIndicator.color = .white
        }
    }
}
