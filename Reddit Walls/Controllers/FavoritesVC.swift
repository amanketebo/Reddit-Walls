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
    
    var favoriteWallpapers = [Wallpaper]()
    
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
        collectionView.delegate = super.self()
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func changeFavoriteStatus(_ sender: UITapGestureRecognizer)
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
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let selectedWallpaperVC = segue.destination as? SelectedWallpaperVC
        {
            if let wallpaperCollectionViewCell = sender as? WallpaperCell
            {
                selectedWallpaperVC.wallpaper = wallpaperCollectionViewCell.wallpaper.image
            }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallpaperCell", for: indexPath) as! WallpaperCell
            
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
