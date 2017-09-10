//
//  Favorites.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 9/10/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation

class Favorites
{
    static let shared = Favorites()
    
    var favorites: [Wallpaper] = []
    
    func remove(_ wallpaper: Wallpaper)
    {
        guard let position = favorites.index(where: { (favoriteWallpaper) -> Bool in
            return wallpaper == favoriteWallpaper
        }) else { return }
        
        favorites.remove(at: position)
    }
}
