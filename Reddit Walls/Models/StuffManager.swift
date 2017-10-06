//
//  Favorites.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 9/10/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit

class StuffManager
{
    static let shared = StuffManager()
    
    var favorites: [Wallpaper] = []
    var wallpaperCache = NSCache<NSURL, UIImage>()
    
    init()
    {
        // Setup wallpaper cache
        wallpaperCache.countLimit = 4
    }
    
    // MARK: - Favorites methods
    
    func remove(_ wallpaper: Wallpaper)
    {
        guard let position = favorites.index(where: { (favoriteWallpaper) -> Bool in
            return wallpaper == favoriteWallpaper
        }) else { return }
        
        favorites.remove(at: position)
    }
    
    // MARK: - Wallpaper Cache methods
    
    func wallpaperForURL(_ url: URL) -> UIImage?
    {
        return wallpaperCache.object(forKey: url as NSURL)
    }
    
    func addToCache(_ url: URL, wallpaper: UIImage)
    {
        wallpaperCache.setObject(wallpaper, forKey: url as NSURL)
    }
}
