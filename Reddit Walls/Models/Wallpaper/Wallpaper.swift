//
//  Wallpaper.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import CoreData

struct Wallpaper: Equatable {

    var id: String
    var title = ""
    var author = ""
    var resolutions = Resolutions()
    var favorite = false
    
    private var lowResStringURL = ""
    private var fullResStringURL = ""
    
    init?(wallpaperData: WallpaperData?) {
        guard let wallpaperData = wallpaperData else {
            return nil
        }
        
        self.id = wallpaperData.id
        self.title = wallpaperData.title ?? ""
        self.author = wallpaperData.author ?? ""
        self.resolutions = Resolutions(images: wallpaperData.preview?.images ?? [])
    }
    
    init(favoriteWallpaper: FavoriteWallpaper) {
        self.id = favoriteWallpaper.id ?? ""
        self.title = favoriteWallpaper.title ?? ""
        self.author = favoriteWallpaper.author ?? ""
        
        var resolutions = Resolutions()
//        resolutions.full = URL(string: favoriteWallpaper.fullResolutionURL ?? "" )
//        resolutions.low = URL(string: favoriteWallpaper.lowResolutionURL ?? "")
        
        self.resolutions = resolutions
        self.favorite = true
    }

    static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        return lhs.title == rhs.title && lhs.author == rhs.author ? true : false
    }
    
    func url(forImageResolution resolution: ImageResolution) -> URL? {
        switch resolution {
        case .full:
            return self.resolutions.full
            
        case .medium:
            return nil
            
        case .low:
            return self.resolutions.low
        }
    }
}
