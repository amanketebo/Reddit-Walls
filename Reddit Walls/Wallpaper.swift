//
//  Wallpaper.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import SwiftyJSON
import Foundation

class Wallpaper
{
    var title = ""
    var author = ""
    var middleResolutionURL = ""
    var fullResolutionURL = ""
    var favorite = false
    
    init(_ title: String,
         _ author: String,
         _ fullResolutionURL: String,
         _ favorite: Bool = false)
    {
        self.title = title
        self.author = author
        self.fullResolutionURL = fullResolutionURL
        self.favorite = favorite
    }
}

extension Wallpaper
{
    convenience init?(_ json: JSON)
    {
        let title = json[SwiftyJSONPaths.title].stringValue
        let author = json[SwiftyJSONPaths.author].stringValue
        let fullResolutionURL = json[SwiftyJSONPaths.fullResolution].stringValue
        
        self.init(title, author, fullResolutionURL)
    }
}
