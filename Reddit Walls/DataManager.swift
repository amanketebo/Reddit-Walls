//
//  DataManager.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit
import Foundation

class DataManager {
    
    func getJSON(completion: @escaping (([WallpaperInfo]) -> Void)) {
        var wallpaperInfos = [WallpaperInfo]()
        
        let api = URL(string: "https://www.reddit.com/r/wallpapers.json?raw_json=1")!
        let request = URLRequest(url: api)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let taskError = error {
                print(taskError.localizedDescription)
            }
            else {
                if let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any],
                    let jsonData = jsonObject?["data"] as? [String: Any],
                    let jsonChildren = jsonData["children"] as? [[String:Any]] {
                    for json in jsonChildren {
                        if let wallpaperInfo = WallpaperInfo(json) {
                            wallpaperInfos.append(wallpaperInfo)
                        }
                    }
                    
                    DispatchQueue.main.async {
                        completion(wallpaperInfos)
                    }
                }
            }
        }
        task.resume()
    }
    
    func getWallpaperForCell(from wallpaperUrl: URL, completion: @escaping (Data) -> Void) {
        let request = URLRequest(url: wallpaperUrl)
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let taskError = error {
                print(taskError.localizedDescription)
            }
            else {
                DispatchQueue.main.async {
                    completion(data!)
                }
            }
        }
        task.resume()
    }
    
}



