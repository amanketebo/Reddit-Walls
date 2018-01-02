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
    private let wallpapersEndpoint = "https://www.reddit.com/r/wallpapers.json"
    private lazy var redditAPI = URL(string: wallpapersEndpoint)!
    let stuffManager = StuffManager.shared
    var pages: [String] = []
    
    static let shared = WallpaperRequester()
    
    typealias WallpapersCallback = ([Wallpaper]?, Error?) -> Void
    typealias WallpaperImageDataCallback = (UIImage?, Error?) -> Void
    
    // MARK: - Wallpaper fetching methods
    
    func fetchWallpapers(page: Int, completion: @escaping WallpapersCallback) {
        var request: URLRequest!
        
        if page == 0 {
            request = URLRequest(url: redditAPI)
        } else {
            if let nextPageURL = nextPageURL(page: page),
                let fullEndpointURL = URL(string: nextPageURL) {
                request = URLRequest(url: fullEndpointURL)
            } else {
                return
            }
        }
        
        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, response, error) in
            if let taskError = error
            {
                DispatchQueue.main.async {
                    completion(nil, taskError)
                }
            }
            else
            {
                let returnedWallpapers = self?.parseWallpaperJSON(data: data!)
                
                DispatchQueue.main.async {
                    completion(returnedWallpapers, nil)
                }
                
                if let nextPage = self?.nextPage(data: data!) {
                    self?.pages.append(nextPage)
                }
            }
        }
        task.resume()
    }
    
    func fetchWallpaperImage(from wallpaperURL: URL, completion: @escaping WallpaperImageDataCallback) {
        
        if let wallpaper = stuffManager.wallpaperForURL(wallpaperURL)
        {
            DispatchQueue.main.async {
                completion(wallpaper, nil)
            }
        }
        else
        {
            let request = URLRequest(url: wallpaperURL)
            
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let taskError = error
                {
                    DispatchQueue.main.async {
                        completion(nil, taskError)
                    }
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
                        DispatchQueue.main.async {
                            completion(nil, error)
                        }
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
    
    private func nextPage(data: Data) -> String? {
        let json = JSON(data)
        
        if let nextPage = json[SwiftyJSONPaths.nextPage].string {
            return nextPage
        } else {
            return nil
        }
    }
    
    private func nextPageURL(page: Int) -> String? {
        guard let nextPage = pages.last else { return nil }
        
        return wallpapersEndpoint + "?after=" + "\(nextPage)"
    }
}



