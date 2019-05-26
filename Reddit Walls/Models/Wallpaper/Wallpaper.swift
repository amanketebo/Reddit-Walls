//
//  Wallpaper.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import CoreData

struct Wallpaper: Codable, Equatable {

    var title = ""
    var author = ""
    var resolutions: Resolutions
    var favorite = false
    
    private var lowResStringURL = ""
    private var fullResStringURL = ""

    init(_ title: String, _ author: String, _ resolutions: Resolutions, favorite: Bool) {
        self.title = title
        self.author = author
        self.resolutions = resolutions
        self.favorite = favorite
    }

    static func == (lhs: Wallpaper, rhs: Wallpaper) -> Bool {
        return lhs.title == rhs.title && lhs.author == rhs.author ? true : false
    }
}
