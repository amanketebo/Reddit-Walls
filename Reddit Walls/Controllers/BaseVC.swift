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
    
    func setupCollectionView(cell: WallpaperCell,  indexPath: IndexPath, wallpapers: [Wallpaper])
    {
        let wallpaper = wallpapers[indexPath.row]
        
        cell.tag = indexPath.row
        cell.title.text = wallpapers[indexPath.row].title
        cell.author.text = wallpapers[indexPath.row].author
        cell.wallpaper.image = UIImage(named: "gray")!
        cell.favoriteIcon.image = UIImage(named: "unfilledstar")!
        
        // Set up favorite icon
        if stuffManager.favoritesContains(wallpaper)
        {
            cell.favoriteIcon.image = UIImage(named: "filledstar")!
        }
        else
        {
            cell.favoriteIcon.image = UIImage(named: "unfilledstar")!
        }
        
        if let wallpaperURL = URL(string: wallpapers[indexPath.row].fullResolutionURL)
        {
            if let wallpaper = stuffManager.wallpaperForURL(wallpaperURL)
            {
                cell.wallpaper.image = wallpaper
            }
            else
            {
                wallpaperRequester.fetchWallpaperImage(from: wallpaperURL) { (wallpaper, error) in
                    if cell.tag == indexPath.row
                    {
                        if let wallpaper = wallpaper
                        {
                            cell.wallpaper.image = wallpaper
                        }
                    }
                }
            }
        }
    }
}

extension BaseVC: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath)
        
        performSegue(withIdentifier: Segue.wallpaper, sender: cell)
    }
}

extension BaseVC: UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
        let availableWidth = view.bounds.size.width - (Dimension.edgeInsets.left * 2)
        
        return CGSize(width: availableWidth, height: Dimension.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets
    {
        return Dimension.edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize
    {
        if collectionView.tag == 0
        {
            return CGSize(width: view.bounds.size.width, height: Dimension.footerHeight)
        }
        else
        {
            return CGSize(width: view.bounds.size.width, height: 0)
        }
    }
}
