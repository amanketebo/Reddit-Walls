//
//  Theme.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 2/18/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit

enum AppTheme: Int {
    case light
    case dark
}

class Theme {
    static let shared = Theme()

    let userDefaults = UserDefaults.standard

    var appTheme: AppTheme {
        let savedTheme = userDefaults.integer(forKey: UserDefaults.themeKey)

        if let appTheme = AppTheme(rawValue: savedTheme) {
            return appTheme
        } else {
            return .light
        }
    }

    func styleNavbar(_ navbar: UINavigationBar?) {
        switch appTheme {
        case .light: navbar?.barTintColor = .redditBlue
        case .dark: navbar?.barTintColor = .lightBlack
        }
    }

    func styleBackground(_ view: UIView) {
        switch appTheme {
        case .light: view.backgroundColor = .white
        case .dark: view.backgroundColor = .darkBlack
        }
    }

    func styleCell(_ themeCell: ThemeCell) {
        styleBackground(themeCell.contentView)
        styleLabel(themeCell.darkLabel)
        styleSwitch(themeCell.darkSwitch)
    }

    func styleLabel(_ label: UILabel) {
        switch appTheme {
        case .light: label.textColor = .black
        case .dark: label.textColor = .white
        }
    }

    func styleSwitch(_ uiSwitch: UISwitch) {
        switch appTheme {
        case .light: uiSwitch.onTintColor = nil
        case .dark: uiSwitch.onTintColor = .redditBlue
        }
    }

    func favoriteIconImage(selected: Bool) -> UIImage {
        switch (appTheme, selected) {
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

    func styleCellSeperator(seperatorView: UIView) {
        switch appTheme {
        case .light: seperatorView.backgroundColor = .lightGray
        case .dark: seperatorView.backgroundColor = .lightBlack
        }
    }
}