//
//  SwiftyJSONPaths.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 9/9/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import SwiftyJSON

struct SwiftyJSONPaths
{
    static let wallpapers: [JSONSubscriptType] = ["data", "children"]
    static let title: [JSONSubscriptType] = ["data", "title"]
    static let author: [JSONSubscriptType] = ["data", "author"]
    static let fullResolution: [JSONSubscriptType] = ["data", "preview", "images", 0, "source","url"]
}
