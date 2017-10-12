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
    let stuffManager = StuffManager.shared
    var wallpaperRequester = WallpaperRequester.shared
    
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
            let wallpaper = stuffManager.favorites[indexPath.row]
            
            cell.tag = indexPath.row
            cell.title.text = stuffManager.favorites[indexPath.row].title
            cell.author.text = stuffManager.favorites[indexPath.row].author
            cell.wallpaper.image = UIImage(named: "gray")!
            cell.favoriteIcon.image = UIImage(named: "unfilledstar")!
            cell.favoriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeFavoriteStatus(_:))))
            
            // Set up favorite icon
            if stuffManager.favoritesContains(wallpaper)
            {
                cell.favoriteIcon.image = UIImage(named: "filledstar")!
            }
            else
            {
                cell.favoriteIcon.image = UIImage(named: "unfilledstar")!
            }
            
            if let wallpaperURL = URL(string: stuffManager.favorites[indexPath.row].fullResolutionURL)
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
            
            return cell
        }
        else
        {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "noFavorites", for: indexPath)
            
            return cell
        }
    }
}
