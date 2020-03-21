//
//  APIServiceError.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/20/20.
//  Copyright © 2020 Amanuel Ketebo. All rights reserved.
//

enum APIServiceError: Error {
    case client
    case server
    case parsing
    case unknown
    
    init(statusCode: Int) {
        switch statusCode {
        case 400...499:
            self = .client
            
        case 500...599:
            self = .server
            
        default:
            self = .unknown
        }
    }
}
