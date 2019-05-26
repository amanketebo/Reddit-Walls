//
//  Resolutions.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 5/26/19.
//  Copyright © 2019 Amanuel Ketebo. All rights reserved.
//

import Foundation

struct Resolutions: Codable {
    
    var fullResURL: URL? {
        return URL(string: fullResURLString)
    }
    var lowResURL: URL? {
        return URL(string: lowResURLString)
    }
    
    private var fullResURLString: String
    private var lowResURLString: String
    
    init(fullResURLString: String = "", lowResURLString: String = "") {
        self.fullResURLString = fullResURLString
        self.lowResURLString = lowResURLString
    }
}
