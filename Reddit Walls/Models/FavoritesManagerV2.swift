//
//  FavoritesManagerV2.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/21/20.
//  Copyright © 2020 Amanuel Ketebo. All rights reserved.
//

import UIKit
import CoreData

protocol FavoritesManaging {
    // MARK: - Properties
    
    var favorites: [Wallpaper] { get set }
    var favoritesSaver: FavoritesSaving { get set }
    
    // MARK: - Saving
    
    func save(wallpaper: Wallpaper, image: UIImage?)
    
    // MARK: - Removing
    
    func remove(wallpaper: Wallpaper)
}

class FavoritesManagerV2: FavoritesManaging {
    // MARK: - Properties
    
    static let shared = FavoritesManagerV2()
    
    var favorites: [Wallpaper] = []
    var favoritesSaver: FavoritesSaving = FavoritesSaver()

    // MARK: - Saving
    
    func setUp() {
        
    }
    
    func save(wallpaper: Wallpaper, image: UIImage?) {
        guard !favorites.contains(wallpaper) else {
            return
        }
        
        favorites.append(wallpaper)
        
        guard let image = image else {
            return
        }
        
        favoritesSaver.store(image, forWallpaper: wallpaper)
    }
    
    // MARK: - Removing
    
    func remove(wallpaper: Wallpaper) {
        guard favorites.contains(wallpaper) else {
            return
        }
        
        favorites.removeAll { $0 == wallpaper }
        favoritesSaver.delete(wallpaper: wallpaper)
    }
}
