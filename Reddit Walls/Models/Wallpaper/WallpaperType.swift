//
//  WallpaperType.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/28/20.
//  Copyright © 2020 Amanuel Ketebo. All rights reserved.
//

enum WallpaperType: CaseIterable {
    case desktop
    case mobile
    
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "reddit.com"
    }
    
    var path: String {
        switch self {
        case .desktop:
            return "/r/wallpapers.json"
            
        case .mobile:
            return "/r/iphonewallpapers.json"
        }
    }
    
    var fetcher: WallpaperFetcher {
       return WallpaperFetcher(wallpaperType: self)
    }
}
