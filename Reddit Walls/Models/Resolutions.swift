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
        return URL(string: fullResStringURL)
    }
    var lowResURL: URL? {
        return URL(string: lowResStringURL)
    }
    
    private var fullResStringURL: String
    private var lowResStringURL: String
    
    init(fullResStringURL: String = "", lowResStringURL: String = "") {
        self.fullResStringURL = fullResStringURL
        self.lowResStringURL = lowResStringURL
    }
}
