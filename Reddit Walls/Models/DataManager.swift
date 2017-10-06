//
//  WallpaperRequester.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

class WallpaperRequester
{
    static let shared = WallpaperRequester()
    
    private let redditAPI = URL(string: "https://www.reddit.com/r/wallpapers.json?raw_json=1")!
    let stuffManager = StuffManager.shared
    
    typealias WallpapersCallback = ([Wallpaper]?, Error?) -> Void
    typealias WallpaperImageDataCallback = (UIImage?, Error?) -> Void
    
    // MARK: - Wallpaper fetching methods
    
    func fetchWallpapers(completion: @escaping WallpapersCallback) {
        let request = URLRequest(url: redditAPI)
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let taskError = error
            {
                completion(nil, taskError)
            }
            else
            {
                let returnedWallpapers = self.parseWallpaperJSON(data: data!)
                
                DispatchQueue.main.async {
                    completion(returnedWallpapers, nil)
                }
            }
        }
        task.resume()
    }
    
    func fetchWallpaperImage(from wallpaperURL: URL, completion: @escaping WallpaperImageDataCallback) {
        
        if let wallpaper = stuffManager.wallpaperForURL(wallpaperURL)
        {
            completion(wallpaper, nil)
        }
        else
        {
            let request = URLRequest(url: wallpaperURL)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let taskError = error
                {
                    completion(nil, taskError)
                }
                else
                {
                    if let wallpaper = UIImage(data: data!)
                    {
                        DispatchQueue.main.async {
                            completion(wallpaper, nil)
                        }
                    }
                    else
                    {
                        completion(nil, error)
                    }
                }
            }
            task.resume()
        }
    }
    
    // MARK: - Helper methods
    
    private func parseWallpaperJSON(data: Data) -> [Wallpaper]
    {
        var wallpapers: [Wallpaper] = []
        let json = JSON(data)
        
        if let returnedWallpapers = json[SwiftyJSONPaths.wallpapers].array
        {
            for wallpaperJSON in returnedWallpapers
            {
                if let wallpaper = Wallpaper(wallpaperJSON)
                {
                    wallpapers.append(wallpaper)
                }
            }
        }
        
        return wallpapers
    }
}



