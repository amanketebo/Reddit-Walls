//
//  URLSessionExtension.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 5/26/19.
//  Copyright © 2019 Amanuel Ketebo. All rights reserved.
//

import Foundation

extension URLSession {
    func dataTask(with url: URL, completeOn queue: DispatchQueue, completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void) -> URLSessionDataTask {
        return URLSession.shared.dataTask(with: url) { (data, response, error) in
            queue.async {
                completionHandler(data, response, error)
            }
        }
    }
}
