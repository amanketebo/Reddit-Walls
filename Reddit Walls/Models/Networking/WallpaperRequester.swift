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

    func fetchWallpaperImage(from wallpaperURL: URL, completion: @escaping WallpaperImageCallback) {
        guard let request = wallpaperService.buildRequest(forImageResourceURL: wallpaperURL) else {
            completion(.failure(APIServiceError.client))
            return
        }
        
        wallpaperService.fetchWallpaper(usingRequest: request,
                                        completionQueue: .main) { result in
            switch result {
            case .success(let image):
                 completion(.success(image))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
