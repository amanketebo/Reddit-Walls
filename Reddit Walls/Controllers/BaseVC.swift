//
//  BaseVC.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 10/5/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    let stuffManager = StuffManager.shared
    let wallpaperRequester = WallpaperRequester.shared

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func setupCollectionView(cell: WallpaperCell, indexPath: IndexPath, wallpapers: [Wallpaper], theme: AppTheme?) {
        let wallpaper = wallpapers[indexPath.row]

        cell.tag = indexPath.row
        cell.title.text = wallpapers[indexPath.row].title
        cell.author.text = wallpapers[indexPath.row].author
        cell.wallpaper.image = #imageLiteral(resourceName: "gray")
        cell.favoriteIcon.image = Theme.shared.favoriteIconImage(selected: false)
        Theme.shared.styleWallpaperCell(cell)

        // Set up favorite icon
        if stuffManager.favoritesContains(wallpaper) {
            cell.favoriteIcon.image = Theme.shared.favoriteIconImage(selected: true)
        } else {
            cell.favoriteIcon.image = Theme.shared.favoriteIconImage(selected: false)
        }

        if let wallpaperURL = URL(string: wallpapers[indexPath.row].fullResolutionURL) {
            if let wallpaper = stuffManager.wallpaperForURL(wallpaperURL) {
                cell.wallpaper.image = wallpaper
                cell.wallpaperHasLoaded = true
            } else {
                cell.wallpaperHasLoaded = false
                wallpaperRequester.fetchWallpaperImage(from: wallpaperURL) { (wallpaper, _) in
                    if cell.tag == indexPath.row {
                        if let wallpaper = wallpaper {
                            cell.wallpaper.image = wallpaper
                            cell.wallpaperHasLoaded = true
                        }
                    }
                }
            }
        }
    }
}
