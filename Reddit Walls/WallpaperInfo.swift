//
//  WallpaperInfo.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation

class WallpaperInfo {
    
    var title = ""
    var author = ""
    var middleResolutionUrl = ""
    var fullResolutionUrl = ""
    var favorite = false
    
    init?(_ json: [String:Any]) {
        // Hey maybe its a good idea to use SwiftyJSON? Just a thought.
        if let data = json["data"] as? [String: Any],
            let title = data["title"] as? String,
            let author = data["author"] as? String,
            let preview = data["preview"] as? [String: Any],
            let images = preview["images"] as? [[String: Any]],
            let source = images[0]["source"] as? [String: Any],
            let resolutions = images[0]["resolutions"] as? [[String: Any]],
            let fullResolutionUrl = source["url"] as? String {
            
            self.title = title
            self.author = author
            self.fullResolutionUrl = fullResolutionUrl
            
            // Get a lesser resolution from json for faster loading
            if resolutions.count == 1 {
                if let middleResolutionUrl = resolutions[0]["url"] as? String{
                    self.middleResolutionUrl = middleResolutionUrl
                }
            }
            else {
                if let middleResolutionUrl = resolutions[(resolutions.count) - 2]["url"] as? String {
                    self.middleResolutionUrl = middleResolutionUrl
                }
            }
            
        }
        else {
            return nil
        }
    }
    
}
