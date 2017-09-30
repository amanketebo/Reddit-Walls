//
//  FavoritesVC.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class FavoritesVC: UIViewController
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
        collectionView.delegate = self
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        if let selectedWallpaperVC = segue.destination as? SelectedWallpaperViewController
        {
            if let wallpaperCollectionViewCell = sender as? WallpaperCell
            {
                selectedWallpaperVC.wallpaperImage = wallpaperCollectionViewCell.wallpaper.image
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
        return stuffManager.favorites.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallpaperCell", for: indexPath) as! WallpaperCell
        
        cell.tag = indexPath.row
        cell.title.text = stuffManager.favorites[indexPath.row].title
        cell.author.text = stuffManager.favorites[indexPath.row].author
        cell.wallpaper.image = UIImage(named: "gray")!
        
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
}


extension FavoritesVC: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        performSegue(withIdentifier: "Wallpaper", sender: collectionView.cellForItem(at: indexPath))
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
}
