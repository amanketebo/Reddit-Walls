//
//  WallpaperServicing.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/20/20.
//  Copyright © 2020 Amanuel Ketebo. All rights reserved.
//

import Foundation

protocol WallpaperServicing {
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    
    func buildRequest(forPage page: Int) -> URLRequest?
    func fetch<T: Decodable>(forType type: T.Type,
                             usingRequest request: URLRequest,
                             completionQueue queue: DispatchQueue,
                             completion: @escaping (Swift.Result<T, APIServiceError>) -> Void)
    func fetchWallpapers(usingRequest request: URLRequest,
                         completionQueue queue: DispatchQueue,
                         completion: @escaping (Swift.Result<[Wallpaper], APIServiceError>) -> Void)
}

extension WallpaperServicing {
    var scheme: String {
        return "https"
    }
    
    var host: String {
        return "reddit.com"
    }
    
    func buildRequest(forPage page: Int) -> URLRequest? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        components.queryItems = [URLQueryItem(name: "after", value: String(page))]
        
        guard let url = components.url else {
            return nil
        }
        
        return URLRequest(url: url)
    }
    
    func fetch<T: Decodable>(forType type: T.Type,
                             usingRequest request: URLRequest,
                             completionQueue queue: DispatchQueue,
                             completion: @escaping (Swift.Result<T, APIServiceError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            var result: Swift.Result<T, APIServiceError>
            
            defer {
                queue.async {
                    completion(result)
                }
            }
            
            if let _ = error,
                let httpURLResponse = response as? HTTPURLResponse {
                let apiServiceError = APIServiceError(statusCode: httpURLResponse.statusCode)
                result = .failure(apiServiceError)
                return
            }
            
            guard let data = data else {
                result = .failure(.parsing)
                return
            }
            
            guard let wallpapers = try? JSONDecoder().decode(type.self, from: data) else {
                result = .failure(.parsing)
                return
            }
            
            result = .success(wallpapers)
        }
        task.resume()
    }
    
    func fetchWallpapers(usingRequest request: URLRequest,
                         completionQueue queue: DispatchQueue,
                         completion: @escaping (Swift.Result<[Wallpaper], APIServiceError>) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            var result: Swift.Result<[Wallpaper], APIServiceError>
            
            defer {
                queue.async {
                    completion(result)
                }
            }
            
            if let _ = error,
                let httpURLResponse = response as? HTTPURLResponse {
                let apiServiceError = APIServiceError(statusCode: httpURLResponse.statusCode)
                result = .failure(apiServiceError)
                return
            }
            
            guard let data = data,
                let wallpapersResponse = try? JSONDecoder().decode(WallpapersResponse.self, from: data) else {
                result = .failure(.parsing)
                return
            }
            
            let wallpapers = wallpapersResponse.data.children.compactMap {
                return Wallpaper($0.data.title, $0.data.author, favorite: false)
            }
            
            result = .success(wallpapers)
        }
        task.resume()
    }
}
