//
//  FavoritesVC.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class FavoritesVC: BaseVC
{
    @IBOutlet weak var collectionView: UICollectionView!
    
    let notificationCenter = NotificationCenter.default
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews()
    {
        // Navigation bar setup
        navigationItem.title = "Favorites"
        
        // Collection view setup
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    @objc func changeFavoriteStatus(_ sender: UITapGestureRecognizer)
    {
        guard let wallpaperCell = sender.view?.superview?.superview as? WallpaperCell else { return }
        
        let wallpaperCellTag = wallpaperCell.tag
        let selectedWallpaper = stuffManager.favorites[wallpaperCellTag]
        
        if stuffManager.favoritesContains(selectedWallpaper)
        {
            selectedWallpaper.favorite = false
            stuffManager.removeFavorite(selectedWallpaper)
        }
        else
        {
            selectedWallpaper.favorite = true
            stuffManager.favorites.append(selectedWallpaper)
        }
        
        collectionView.reloadData()
        notificationCenter.post(name: .favoritesUpdated, object: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let selectedWallpaperVC = segue.destination as? SelectedWallpaperVC
        {
            if let wallpaperTuple = sender as? (cell: WallpaperCell, wallpaper: Wallpaper?)
            {
                selectedWallpaperVC.wallpaper = wallpaperTuple.cell.wallpaper.image
                selectedWallpaperVC.wallpaperHasLoaded = wallpaperTuple.cell.wallpaperHasLoaded
                selectedWallpaperVC.selectedWallpaper = wallpaperTuple.wallpaper
            }
        }
    }
}

extension FavoritesVC: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WallpaperCell else { return }
        guard stuffManager.favorites.count > 0 else { return }
        
        let associatedWallpaper = stuffManager.favorites[indexPath.row]
        
        if let selectedWallpaperVC = UIStoryboard.init(name: "SelectedWallpaper", bundle: nil).instantiateInitialViewController() as? SelectedWallpaperVC {
            selectedWallpaperVC.wallpaper = cell.wallpaper.image
            selectedWallpaperVC.selectedWallpaper = associatedWallpaper
            selectedWallpaperVC.wallpaperHasLoaded = cell.wallpaperHasLoaded
            
            present(selectedWallpaperVC, animated: true, completion: nil)
        }
    }
}

extension FavoritesVC: UICollectionViewDelegateFlowLayout
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

extension FavoritesVC: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        if stuffManager.favorites.count == 0
        {
            return 1
        }
        else
        {
            return stuffManager.favorites.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        if stuffManager.favorites.count != 0
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallpaperCell.identifier, for: indexPath) as! WallpaperCell
            
            setupCollectionView(cell: cell, indexPath: indexPath, wallpapers: stuffManager.favorites)
            cell.favoriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeFavoriteStatus(_:))))
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noFavorites", for: indexPath)

            return cell
        }
    }
}
