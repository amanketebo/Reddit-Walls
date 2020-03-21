//
//  WallpaperRequester.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit
import Foundation

struct RedditURL {
    static let wallpapers = URL(staticString: "https://www.reddit.com/r/wallpapers.json")
    static let iphoneWallpapers = URL(staticString: "https://www.reddit.com/r/iphonewallpapers.json")
}

class WallpaperRequester {
    private(set) var url: URL
    var nextPage: String?
    var wallpaperCache = NSCache<NSURL, UIImage>()
    let favoritesManager = FavoritesManager.shared
    
    var wallpaperService: WallpaperServicing = WallpaperService(wallpaperType: .mobile)

    static let wallpapers = WallpaperRequester(RedditURL.wallpapers)
    static let iphoneWallpapers = WallpaperRequester(RedditURL.iphoneWallpapers)

    init(_ url: URL) {
        self.url = url
        self.wallpaperCache.countLimit = 8
    }

    typealias WallpapersCallback = (Result<[Wallpaper], APIServiceError>) -> Void
    typealias WallpaperImageCallback = (Result<UIImage, Error>) -> Void

    // MARK: - Wallpaper fetching methods

    func fetchWallpapers(page: Int, completion: @escaping WallpapersCallback) {
        guard let request = wallpaperService.buildRequest(forPage: page) else {
            completion(.failure(APIServiceError.client))
            return
        }
        
        wallpaperService.fetchWallpapers(usingRequest: request,
                                         completionQueue: .main) { result in
            switch result {
            case .success(let wallpapersResponse):
                self.nextPage = wallpapersResponse.nextPage
                completion(.success(wallpapersResponse.wallpapers))
                
            case .failure(let apiServiceError):
                completion(.failure(apiServiceError))
            }
        }
    }

    // MARK: - Wallpaper Cache methods

    func cachedWallpaperImage(for url: URL) -> UIImage? {
        return wallpaperCache.object(forKey: url as NSURL)
    }

    func addToCache(_ url: URL, wallpaper: UIImage) {
        wallpaperCache.setObject(wallpaper, forKey: url as NSURL)
    }

    func fetchWallpaperImage(from wallpaperURL: URL, completion: @escaping WallpaperImageCallback) {
        if let cachedWallpaper = self.cachedWallpaperImage(for: wallpaperURL) {
            completion(.success(cachedWallpaper))
        } else {
            URLSession.shared.dataTask(with: url, completeOn: .main) { (data, _, error) in
                if let taskError = error {
                    completion(.failure(taskError))
                } else {
                    if let wallpaper = UIImage(data: data!) {
                        self.addToCache(wallpaperURL, wallpaper: wallpaper)
                        completion(.success(wallpaper))
                    } else {
                        completion(.failure(RedditError.invalidDataForImage))
                    }
                }
            }.resume()
        }
    }

    // MARK: - Helper methods

    private func nextPageURL(page: Int) -> URL? {
        guard let nextPage = nextPage else { return nil }

        return URL(string: url.absoluteString + "?after=" + "\(nextPage)")
    }
}
