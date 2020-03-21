//
//  WallpaperFetcher.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/21/20.
//  Copyright © 2020 Amanuel Ketebo. All rights reserved.
//

import UIKit

protocol WallpaperFetching {
    // MARK: Properties
    
    var wallpaperService: WallpaperService { get set }
    
    // MARK: Fetching
    
    func fetchWallpapers(forPage page: Int,
                         completionQueue queue: DispatchQueue,
                         completion: @escaping (Swift.Result<[Wallpaper], APIServiceError>) -> Void)
    
    func fetchImage(forWallpaper: Wallpaper,
                    completionQueue queue: DispatchQueue,
                    completion: @escaping (Swift.Result<[Wallpaper], APIServiceError>) -> Void)
}

class WallpaperFetcher {
    // MARK: Properties
    
    var wallpaperService: WallpaperServicing
    
    // MARK: Init
    
    init(wallpaperType type: WallpaperType) {
        self.wallpaperService = WallpaperService(wallpaperType: type)
    }
    
    // MARK: Fetching
    
    func fetchWallpapers(forPage page: Int,
                         completionQueue queue: DispatchQueue,
                         completion: @escaping (Swift.Result<[Wallpaper], APIServiceError>) -> Void) {
        guard let request = wallpaperService.buildRequest(forPage: page) else {
            completion(.failure(.client))
            return
        }
        
        wallpaperService.fetchWallpapers(usingRequest: request,
                                         completionQueue: queue,
                                         completion: completion)
    }
    
    func fetchImage(forWallpaper wallpaper: Wallpaper,
                    usingResolution resolution: ImageResolution,
                    completionQueue queue: DispatchQueue,
                    completion: @escaping (Swift.Result<UIImage, APIServiceError>) -> Void) {
        guard let imageURL = wallpaper.url(forImageResolution: .low),
            let request = wallpaperService.buildRequest(forImageResourceURL: imageURL) else {
            completion(.failure(.client))
            return
        }
        
        wallpaperService.fetchWallpaper(usingRequest: request,
                                        completionQueue: .main,
                                        completion: completion)
    }
}
