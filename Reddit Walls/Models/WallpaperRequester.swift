//
//  WallpaperRequester.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit
import SwiftyJSON
import Foundation

struct RedditURL {
    static let wallpapers = URL(staticString: "https://www.reddit.com/r/wallpapers.json")
    static let iphoneWallpapers = URL(staticString: "https://www.reddit.com/r/iphonewallpapers.json")
}

enum Result<T> {
    case success(T)
    case failure(Error)
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

    typealias WallpapersCallback = (Result<[Wallpaper]>) -> Void
    typealias WallpaperImageCallback = (Result<UIImage>) -> Void

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
            guard let strongSelf = self else { return }
            if let taskError = error {
                DispatchQueue.main.async {
                    completion(.failure(taskError))
                }
            } else {
                if let nextPage = self?.nextPage(data: data!) {
                    strongSelf.nextPage = nextPage
                } else {
                    strongSelf.nextPage = nil
                }

                let returnedWallpapers = strongSelf.parseWallpaperJSON(data: data!)

                DispatchQueue.main.async {
                    completion(.success(returnedWallpapers))
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
        let request = URLRequest(url: wallpaperURL)

        if let cachedWallpaper = self.wallpaperForURL(wallpaperURL) {
            completion(.success(cachedWallpaper))
        } else {
            let task = URLSession.shared.dataTask(with: request) { (data, _, error) in
                if let taskError = error {
                    DispatchQueue.main.async {
                        completion(.failure(taskError))
                    }
                } else {
                    if let wallpaper = UIImage(data: data!) {
                        self.addToCache(wallpaperURL, wallpaper: wallpaper)
                        DispatchQueue.main.async {
                            completion(.success(wallpaper))
                        }
                    } else {
                        DispatchQueue.main.async {
                            completion(.failure(error!))
                        }
                    }
                }
            }

            task.resume()
        }
    }

    // MARK: - Helper methods

    private func parseWallpaperJSON(data: Data) -> [Wallpaper] {
        var wallpapers: [Wallpaper] = []
        let json = JSON(data)

        if let returnedWallpapers = json[SwiftyJSONPaths.wallpapers].array {
            for wallpaperJSON in returnedWallpapers {
                if let wallpaper = Wallpaper(wallpaperJSON) {
                    wallpapers.append(wallpaper)
                }
            }
        }

        return wallpapers
    }

    private func nextPage(data: Data) -> String? {
        let json = JSON(data)

        if let nextPage = json[SwiftyJSONPaths.nextPage].string {
            return nextPage
        } else {
            return nil
        }
    }

    private func nextPageURL(page: Int) -> URL? {
        guard let nextPage = nextPage else { return nil }

        return URL(string: url.absoluteString + "?after=" + "\(nextPage)")
    }
}
