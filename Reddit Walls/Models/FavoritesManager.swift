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
    
    func saveFavorites() {
        if let data = try? JSONEncoder().encode(favorites) {
            userDefaults.set(data, forKey: FavoritesManager.favorites)
        } else {
            print("Some issue saving favorites")
        }
    }
    
    func fetchSavedFavorites() -> [Wallpaper] {
        if let data = userDefaults.data(forKey: FavoritesManager.favorites),
            let wallpapers = try? JSONDecoder().decode([Wallpaper].self, from: data) {
            return wallpapers
        } else {
            return []
        }
    }

    func removeFavorite(_ wallpaper: Wallpaper) {
        guard let position = favorites.firstIndex(where: { (favoriteWallpaper) -> Bool in
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
        favoriteWallpaper.uid = wallpaper.resolutions.full?.absoluteString
        if let imageData = image.pngData() {
            favoriteWallpaper.imageData = imageData as NSData
        }

        saveContext()
    }

    func fetchFavoriteWallpaper(_ wallpaper: Wallpaper) -> UIImage? {
        let request: NSFetchRequest<FavoriteWallpaper> = FavoriteWallpaper.fetchRequest()

        request.predicate = NSPredicate(format: "uid = %@", wallpaper.resolutions.full?.absoluteString ?? "")

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
