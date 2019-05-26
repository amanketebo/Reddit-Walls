//
//  SwiftyJSONPaths.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 9/9/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation

struct WallpapersResponse: Decodable {
    var data: WallpapersData
}

struct WallpapersData: Decodable {
    var children: [WallpapersDataChild]
    var before: String?
    var after: String?
}

struct WallpapersDataChild: Decodable {
    var data: WallpaperData
}

struct WallpaperData: Decodable {
    var title: String
    var author: String
    var url: String
}
