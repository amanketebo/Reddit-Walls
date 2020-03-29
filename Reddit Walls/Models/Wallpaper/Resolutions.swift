//
//  Resolutions.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 5/26/19.
//  Copyright © 2019 Amanuel Ketebo. All rights reserved.
//

import Foundation

struct Resolutions: Codable {
    var full: URL?
    var medium: URL?
    var low: URL?
    
    init(images: [Image]) {
        guard let image = images.first else {
            return
        }
        
        self.full = URL(string: cleanURL(string: image.source?.url ?? ""))
        
        guard let resolutions = image.resolutions,
            resolutions.count >= 2 else {
            return
        }
        
        self.medium = URL(string: cleanURL(string: resolutions.first?.url ?? ""))
        self.low = URL(string: cleanURL(string: resolutions.last?.url ?? ""))
    }
    
    init() { }
    
    private func cleanURL(string: String) -> String {
        return string.replacingOccurrences(of: "amp;", with: "")
    }
}
