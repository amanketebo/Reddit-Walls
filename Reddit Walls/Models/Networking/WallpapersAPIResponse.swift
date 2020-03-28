//
//  SwiftyJSONPaths.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 9/9/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation

struct WallpapersAPIResponse: Decodable {
    let data: WallpapersData?
}

struct WallpapersData: Decodable {
    let children: [WallpapersDataChild]?
    let before: String?
    let after: String?
}

struct WallpapersDataChild: Decodable {
    let data: WallpaperData?
}

struct WallpaperData: Decodable {
    let id: String
    let title: String?
    let author: String?
    let url: String?
    let preview: Preview?
}

struct Preview: Decodable {
    let images: [Image]?
}

struct Image: Decodable {
    let source: Source?
    let resolutions: [APIResolution]?
}

struct Source: Decodable {
    let url: String?
    let width: Int?
    let height: Int?
}

struct APIResolution: Decodable {
    let url: String?
    let width: Int?
    let height: Int?
}
