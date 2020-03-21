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

struct Resolutions: Codable {
    var full: URL?
    var medium: URL?
    var low: URL?
    
    init(images: [Image]) {
        guard let image = images.first else {
            return
        }
        
        self.full = URL(string: cleanURL(string: image.source?.url ?? ""))
        
        guard let resolutions = image.resolutions,
            resolutions.count >= 2 else {
            return
        }
        
        self.medium = URL(string: cleanURL(string: resolutions.first?.url ?? ""))
        self.low = URL(string: cleanURL(string: resolutions.last?.url ?? ""))
    }
    
    init() { }
    
    private func cleanURL(string: String) -> String {
        return string.replacingOccurrences(of: "amp;", with: "")
    }
}

struct Wallpaper: Codable, Equatable {

    var title = ""
    var author = ""
    var resolutions: Resolutions
    var favorite = false
    
    private var lowResStringURL = ""
    private var fullResStringURL = ""
    
    init(wallpaperData: WallpaperData?) {
        self.title = wallpaperData?.title ?? ""
        self.author = wallpaperData?.author ?? ""
        self.resolutions = Resolutions(images: wallpaperData?.preview?.images ?? [])
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
