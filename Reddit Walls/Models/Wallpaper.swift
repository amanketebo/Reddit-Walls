//
//  Wallpaper.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import CoreData

class Wallpaper: Equatable {
    static let title = "title"
    static let author = "author"
    static let lowerResolutionURL = "lowerResolutionURL"
    static let fullResolutionURL = "fullResolutionURL"

    var title = ""
    var author = ""
    var lowerResolutionURL = ""
    var fullResolutionURL = ""
    var favorite = false

    init(_ title: String,
         _ author: String,
         _ lowerResolutionURL: String,
         _ fullResolutionURL: String,
         _ favorite: Bool = false) {
        self.title = title
        self.author = author
        self.fullResolutionURL = fullResolutionURL
        self.lowerResolutionURL = lowerResolutionURL
        self.favorite = favorite
    }

    static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        if lhs.title == rhs.title &&
            lhs.author == rhs.author &&
            lhs.lowerResolutionURL == rhs.lowerResolutionURL &&
            lhs.fullResolutionURL == rhs.fullResolutionURL {
            return true
        } else {
            return false
        }
    }
}

extension Wallpaper {
    convenience init?(_ wallpaperInfo: [String: String], favorite: Bool) {
        if let title = wallpaperInfo[Wallpaper.title],
            let author = wallpaperInfo[Wallpaper.author],
            let fullResolutionURL = wallpaperInfo[Wallpaper.fullResolutionURL],
            let lowerResolutionURL = wallpaperInfo[Wallpaper.lowerResolutionURL] {

            if fullResolutionURL.isEmpty || lowerResolutionURL.isEmpty {
                return nil
            } else {
                self.init(title, author, lowerResolutionURL, fullResolutionURL, favorite)
            }
        } else {
            return nil
        }
    }
}
