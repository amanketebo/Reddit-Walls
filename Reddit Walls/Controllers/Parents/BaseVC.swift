//
//  BaseVC.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 10/5/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class BaseVC: UIViewController {
    let favoritesManager = FavoritesManager.shared
    var wallpaperRequester: WallpaperRequester = WallpaperRequester(subredditURL: "https://www.reddit.com/r/wallpapers.json")

    init(wallpaperRequester: WallpaperRequester) {
        self.wallpaperRequester = wallpaperRequester
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

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
        if favoritesManager.favoritesContains(wallpaper) {
            cell.favoriteIcon.image = Theme.shared.favoriteIconImage(selected: true)
        } else {
            cell.favoriteIcon.image = Theme.shared.favoriteIconImage(selected: false)
        }

        if let wallpaperURL = URL(string: wallpapers[indexPath.row].fullResolutionURL) {
            cell.wallpaperHasLoaded = false
            wallpaperRequester.fetchWallpaperImage(from: wallpaperURL) { (result) in

                switch result {
                case .success(let wallpaper):
                    cell.wallpaper.image = wallpaper
                    cell.wallpaperHasLoaded = true
                case .failure(_): break
                }
            }
        }
    }

    func setupCollectionView(cell: LoadingCell) {
        Theme.shared.styleLoadingCell(cell)
    }

    func setupCollectionView(noFavoritesCell: NoFavoritesCell) {
        Theme.shared.styleLabel(noFavoritesCell.label, favoritesScreen: true)
        Theme.shared.styleBackground(noFavoritesCell.contentView)
    }
}
