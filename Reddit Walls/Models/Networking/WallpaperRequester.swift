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

    static let wallpapers = WallpaperRequester(RedditURL.wallpapers)
    static let iphoneWallpapers = WallpaperRequester(RedditURL.iphoneWallpapers)

    init(_ url: URL) {
        self.url = url
        self.wallpaperCache.countLimit = 8
    }

    typealias WallpapersCallback = (Result<[Wallpaper], Error>) -> Void
    typealias WallpaperImageCallback = (Result<UIImage, Error>) -> Void

    // MARK: - Wallpaper fetching methods

    func fetchWallpapers(page: Int, completion: @escaping WallpapersCallback) {
        var request: URLRequest!

        if page == 0 {
            request = URLRequest(url: url)
        } else {
            if let nextPageURL = nextPageURL(page: page) {
                request = URLRequest(url: nextPageURL)
            } else {
                DispatchQueue.main.async {
                    completion(.success([]))
                }
                return
            }
        }

        let task = URLSession.shared.dataTask(with: request) { [weak self] (data, _, error) in
            guard let self = self else { return }
            if let taskError = error {
                DispatchQueue.main.async {
                    completion(.failure(taskError))
                }
            } else {
                if let data = data,
                    let wallpaperResponse = try? JSONDecoder().decode(WallpapersResponse.self, from: data) {
                    self.nextPage = wallpaperResponse.data.after
                    var wallpapers: [Wallpaper] = []
                    
                    for wallpaperData in wallpaperResponse.data.children {
                        let wallpaper = Wallpaper(wallpaperData.data.title, wallpaperData.data.author, Resolutions(), favorite: false)
                        wallpapers.append(wallpaper)
                    }
                    
                    DispatchQueue.main.async {
                        completion(.success(wallpapers))
                    }
                } else {
                    print("No data and no error")
                }
            }
        }
        task.resume()
    }

    // MARK: - Wallpaper Cache methods

    func wallpaperForURL(_ url: URL) -> UIImage? {
        return wallpaperCache.object(forKey: url as NSURL)
    }

    func addToCache(_ url: URL, wallpaper: UIImage) {
        wallpaperCache.setObject(wallpaper, forKey: url as NSURL)
    }

    func fetchWallpaperImage(from wallpaperURL: URL, completion: @escaping WallpaperImageCallback) {
        if let cachedWallpaper = self.wallpaperForURL(wallpaperURL) {
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
