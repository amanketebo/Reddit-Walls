//
//  WallpaperAPIService.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/20.
//  Copyright © 2020 Amanuel Ketebo. All rights reserved.
//

import Foundation

class RedditWallpaperService: WallpaperServicing {
    var host: String {
        return "reddit.com"
    }
    
    var path: String {
        return "/r/wallpapers.json"
    }
    
    func buildRequest(forPage page: Int) -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [URLQueryItem(name: "after", value: String(page))]
        
        guard let url = components.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
}
