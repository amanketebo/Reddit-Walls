//
//  WallpapersDataSource.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 8/22/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit

class WallpapersDataSource: NSObject, UICollectionViewDataSource {
    weak var wallpapersVC: WallpapersVC?
    var wallpapers: [Wallpaper] = []
    var currentPage = 0
    var initialFetch = true
    var wallpaperFetcher = WallpaperFetcher(wallpaperType: .desktop)
    let favoritesManager: FavoritesManaging = FavoritesManager.shared
    let theme = Theme.shared
    let userDefaults = UserDefaults.standard

    init(wallpapers: [Wallpaper] = [], initialFetch: Bool = true, wallpaperType: WallpaperType = .desktop) {
        self.wallpapers = wallpapers
        self.initialFetch = initialFetch
        self.wallpaperFetcher = WallpaperFetcher(wallpaperType: wallpaperType)
    }

    // TODO: - Remove wallpaper after unfavoriting
    //       - Make saving of wallpaper not block the main thread
    
    @objc func updateFavorite(_ sender: UITapGestureRecognizer) {
        guard let wallpaperCell = sender.view?.superview?.superview as? WallpaperCell else { return }
        guard let wallpaperImageView = wallpaperCell.subviews.first?.subviews.first as? UIImageView else { return }

        let wallpaperCellIndexPath = IndexPath(row: wallpaperCell.tag, section: 0)
        var selectedWallpaper = wallpapers[wallpaperCellIndexPath.row]

        if favoritesManager.favorites.contains(selectedWallpaper) {
            selectedWallpaper.favorite = false
            favoritesManager.remove(wallpaper: selectedWallpaper)
        } else {
            selectedWallpaper.favorite = true
            favoritesManager.save(wallpaper: selectedWallpaper, image: wallpaperImageView.image)
        }


        if let wallpaperCell = wallpapersVC?.collectionView.cellForItem(at: wallpaperCellIndexPath) as? WallpaperCell {
            wallpaperCell.favoriteIcon.image = theme.favoriteIconImage(selected: selectedWallpaper.favorite)
        }
    }

    // TODO: - Show an image in the cell for a failed fetch

    func fetchWallpaper(_ wallpaper: Wallpaper, for cell: WallpaperCell) {
        cell.wallpaperHasLoaded = false
        wallpaperFetcher.fetchImage(forWallpaper: wallpaper,
                                    usingResolution: .low,
                                    completionQueue: .main) { result in
            switch result {
            case .success(let image):
                cell.wallpaper.image = image
                cell.wallpaperHasLoaded = true
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    func fetchWallpapers(completion: @escaping WallpaperRequester.WallpapersCallback) {
        wallpaperFetcher.fetchWallpapers(forPage: currentPage, completionQueue: .main) { result in
            switch result {
            case .success(let response):
                completion(.success(response.wallpapers))
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // MARK: - UICollectionViewDataSource methods

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if initialFetch || (!initialFetch && currentPage == 0) {
            return wallpapers.count
        } else {
            return wallpapers.count + 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < wallpapers.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallpaperCell.identifier, for: indexPath) as! WallpaperCell
            let wallpaper = wallpapers[indexPath.row]
            let isFavorite = favoritesManager.favorites.contains(wallpaper)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateFavorite(_:)))

            theme.styleWallpaperCell(cell)
            cell.setup(wallpaper, at: indexPath)
            cell.favoriteIcon.image = theme.favoriteIconImage(selected: isFavorite)
            cell.favoriteIcon.addGestureRecognizer(tapGestureRecognizer)
            fetchWallpaper(wallpaper, for: cell)

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell

            theme.styleLoadingCell(cell)

            return cell
        }
    }
}
