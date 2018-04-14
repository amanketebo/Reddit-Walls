//
//  Favorites.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 9/10/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit

class StuffManager {
    static let shared = StuffManager()
    static let favorites = "favorites"

    var favorites: [Wallpaper] = [] {
        didSet {
            saveFavorites()
        }
    }
    var wallpaperCache = NSCache<NSURL, UIImage>()
    let userDefaults = UserDefaults.standard

    init() {
        // Setup wallpaper cache
        wallpaperCache.countLimit = 4
        favorites = fetchSavedFavorites()
    }

    // MARK: - Favorites methods

    func fetchSavedFavorites() -> [Wallpaper] {
        if let favorites = userDefaults.array(forKey: StuffManager.favorites) as? [[String: String]] {
            var savedFavorites = [Wallpaper]()

            favorites.forEach({ (wallpaperInfo) in
                if let wallpaper = Wallpaper(wallpaperInfo, favorite: true) {
                    savedFavorites.append(wallpaper)
                }
            })

            return savedFavorites
        }

        return []
    }

    func saveFavorites() {
        // User defaults can only contain Property Lists
        var favoritesPropertyList = [[String: String]]()

        // Convert each Wallpaper element to a Property List
        favorites.forEach { (wallpaper) in
            var wallpaperInfo = [String: String]()

            wallpaperInfo[Wallpaper.title] = wallpaper.title
            wallpaperInfo[Wallpaper.author] = wallpaper.author
            wallpaperInfo[Wallpaper.url] = wallpaper.fullResolutionURL

            favoritesPropertyList.append(wallpaperInfo)
        }

        userDefaults.set(favoritesPropertyList, forKey: StuffManager.favorites)
    }

    func removeFavorite(_ wallpaper: Wallpaper) {
        guard let position = favorites.index(where: { (favoriteWallpaper) -> Bool in
            return wallpaper == favoriteWallpaper
        }) else { return }

        favorites.remove(at: position)
    }

    func favoritesContains(_ wallpaper: Wallpaper) -> Bool {
        if favorites.contains(where: { (favoriteWallpaper) -> Bool in
            return wallpaper == favoriteWallpaper
        }) {
            return true
        } else {
            return false
        }
    }

    // MARK: - Wallpaper Cache methods

    func wallpaperForURL(_ url: URL) -> UIImage? {
        return wallpaperCache.object(forKey: url as NSURL)
    }

    func addToCache(_ url: URL, wallpaper: UIImage) {
        wallpaperCache.setObject(wallpaper, forKey: url as NSURL)
    }
}
