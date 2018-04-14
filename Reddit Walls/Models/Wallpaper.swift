//
//  Wallpaper.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import SwiftyJSON
import Foundation

class Wallpaper: Equatable {
    static let title = "title"
    static let author = "author"
    static let url = "url"

    var title = ""
    var author = ""
    var middleResolutionURL = ""
    var fullResolutionURL = ""
    var favorite = false

    init(_ title: String,
         _ author: String,
         _ fullResolutionURL: String,
         _ favorite: Bool = false) {
        self.title = title
        self.author = author
        self.fullResolutionURL = fullResolutionURL
        self.favorite = favorite
    }

    static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        if lhs.title == rhs.title &&
            lhs.author == rhs.author &&
            lhs.middleResolutionURL == rhs.middleResolutionURL &&
            lhs.fullResolutionURL == rhs.fullResolutionURL {
            return true
        } else {
            return false
        }
    }
}

extension Wallpaper {
    convenience init?(_ json: JSON) {
        let title = json[SwiftyJSONPaths.title].stringValue
        let author = json[SwiftyJSONPaths.author].stringValue
        let fullResolutionURL = json[SwiftyJSONPaths.fullResolution].stringValue

        self.init(title, author, fullResolutionURL)
    }

    convenience init?(_ wallpaperInfo: [String: String], favorite: Bool) {
        if let title = wallpaperInfo["title"],
            let author = wallpaperInfo["author"],
            let fullResolutionURL = wallpaperInfo["url"] {
            self.init(title, author, fullResolutionURL, favorite)
        } else {
            return nil
        }
    }
}
