//
//  BaseVC.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 10/5/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class BaseVC: UIViewController
{
    let stuffManager = StuffManager.shared
    let wallpaperRequester = WallpaperRequester.shared
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    func setupCollectionView(cell: WallpaperCell,  indexPath: IndexPath, wallpapers: [Wallpaper], theme: AppTheme?)
    {
        let wallpaper = wallpapers[indexPath.row]
        
        cell.tag = indexPath.row
        cell.title.text = wallpapers[indexPath.row].title
        cell.author.text = wallpapers[indexPath.row].author
        cell.wallpaper.image = #imageLiteral(resourceName: "gray")
        cell.favoriteIcon.image = #imageLiteral(resourceName: "unfilledstar")

        if let theme = theme {
            switch theme {
            case .dark:
                cell.contentView.backgroundColor = .darkBlack
                cell.title.textColor = .white
                cell.submittedByLabel.textColor = .white
                cell.author.textColor = .white
                cell.seperator.backgroundColor = .lightBlack
                cell.favoriteIcon.image = #imageLiteral(resourceName: "unfilledbluestar")
            case .light:
                cell.contentView.backgroundColor = .white
                cell.title.textColor = .black
                cell.submittedByLabel.textColor = .black
                cell.author.textColor = .redditBlue
                cell.seperator.backgroundColor = .lightGray
                cell.favoriteIcon.image = #imageLiteral(resourceName: "unfilledblackstar")
            }
        }
        
        // Set up favorite icon
        if stuffManager.favoritesContains(wallpaper)
        {
            cell.favoriteIcon.image = #imageLiteral(resourceName: "filledstar")

            if let theme = theme {
                switch theme {
                case .dark:
                    cell.favoriteIcon.image = #imageLiteral(resourceName: "filledbluestar")
                case .light:
                    cell.favoriteIcon.image = #imageLiteral(resourceName: "filledblackstar")
                }
            }
        }
        else
        {
            cell.favoriteIcon.image = #imageLiteral(resourceName: "unfilledstar")

            if let theme = theme {
                switch theme {
                case .dark:
                    cell.favoriteIcon.image = #imageLiteral(resourceName: "unfilledbluestar")
                case .light:
                    cell.favoriteIcon.image = #imageLiteral(resourceName: "unfilledblackstar")
                }
            }
        }
        
        if let wallpaperURL = URL(string: wallpapers[indexPath.row].fullResolutionURL)
        {
            if let wallpaper = stuffManager.wallpaperForURL(wallpaperURL)
            {
                cell.wallpaper.image = wallpaper
                cell.wallpaperHasLoaded = true
            }
            else
            {
                cell.wallpaperHasLoaded = false
                wallpaperRequester.fetchWallpaperImage(from: wallpaperURL) { (wallpaper, error) in
                    if cell.tag == indexPath.row
                    {
                        if let wallpaper = wallpaper
                        {
                            cell.wallpaper.image = wallpaper
                            cell.wallpaperHasLoaded = true
                        }
                    }
                }
            }
        }
    }
}

