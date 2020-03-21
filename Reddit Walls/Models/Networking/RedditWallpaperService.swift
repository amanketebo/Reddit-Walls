//
//  WallpaperAPIService.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/20.
//  Copyright © 2020 Amanuel Ketebo. All rights reserved.
//

import Foundation

class DesktopWallpaperService: WallpaperServicing {    
    var path: String {
        return "/r/wallpapers.json"
    }
}

class MobileWallpaperService: WallpaperServicing {
    var path: String {
        return "/r/iphonewallpapers.json"
    }
}
