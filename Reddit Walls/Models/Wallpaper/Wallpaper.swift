//
//  Wallpaper.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import CoreData

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
}

enum ImageResolution {
    case full
    case medium
    case low
}

struct Wallpaper: Codable, Equatable {

    var title = ""
    var author = ""
    var resolutions: Resolutions
    var favorite = false
    
    private var lowResStringURL = ""
    private var fullResStringURL = ""

    init(_ title: String, _ author: String, _ resolutions: Resolutions = Resolutions(), favorite: Bool) {
        self.title = title
        self.author = author
        self.resolutions = resolutions
        self.favorite = favorite
    }

    static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        return lhs.title == rhs.title && lhs.author == rhs.author ? true : false
    }
    
    func url(forImageResolution resolution: ImageResolution) -> URL? {
        switch resolution {
        case .full:
            return self.resolutions.fullResURL
            
        case .medium:
            return nil
            
        case .low:
            return self.resolutions.fullResURL
        }
    }
}
