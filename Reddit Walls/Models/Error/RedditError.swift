//
//  RequestError.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 5/25/19.
//  Copyright © 2019 Amanuel Ketebo. All rights reserved.
//

import Foundation

enum RedditError: LocalizedError {
    case invalidDataForImage
    
    var errorDescription: String? {
        switch self {
        case .invalidDataForImage: return "Invalid data received for UIImage"
        }
    }
}
