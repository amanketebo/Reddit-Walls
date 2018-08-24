//
//  Favorites.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 9/10/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class FavoritesManager {
    static let shared = FavoritesManager()
    static let favorites = "favorites"

    lazy var context = persistentContainer.viewContext

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "RedditWalls")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })

        return container
    }()

    var favorites: [Wallpaper] = [] {
        didSet {
            saveFavorites()
        }
    }
    let userDefaults = UserDefaults.standard

    init() {
        favorites = fetchSavedFavorites()
    }

    // MARK: - Favorites methods
    func fetchSavedFavorites() -> [Wallpaper] {
        if let favorites = userDefaults.array(forKey: FavoritesManager.favorites) as? [[String: String]] {
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
            wallpaperInfo[Wallpaper.fullResolutionURL] = wallpaper.fullResolutionURL
            wallpaperInfo[Wallpaper.lowerResolutionURL] = wallpaper.lowerResolutionURL
            favoritesPropertyList.append(wallpaperInfo)
        }

        userDefaults.set(favoritesPropertyList, forKey: FavoritesManager.favorites)
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

    // MARK: Core Data Methods
    func saveFavoriteWallpaper(_ wallpaper: Wallpaper, image: UIImage) {
        let favoriteWallpaper = FavoriteWallpaper(context: context)
        favoriteWallpaper.uid = wallpaper.fullResolutionURL

        if let imageData = image.pngData() {
            favoriteWallpaper.imageData = imageData as NSData
        }

        saveContext()
    }

    func fetchFavoriteWallpaper(_ wallpaper: Wallpaper) -> UIImage? {
        let request: NSFetchRequest<FavoriteWallpaper> = FavoriteWallpaper.fetchRequest()

        request.predicate = NSPredicate(format: "uid = %@", wallpaper.fullResolutionURL)

        if let foundFavoriteWallpapers = try? context.fetch(request) {
            if let imageData = foundFavoriteWallpapers.first?.imageData {
                return UIImage(data: imageData as Data)
            } else {
                return nil
            }
        } else {
            return nil
        }
    }

    // MARK: - Core Data Saving support
    func saveContext() {
        let context = persistentContainer.viewContext

        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
