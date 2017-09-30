//
//  FavoritesViewController.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class FavoritesViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var wallpaperRequester = WallpaperRequester.shared
    var favoriteWallpapers = [Wallpaper]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Favorites"
        
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if favoriteWallpapers.count == 0 {
            let noFavorites = UILabel()
            noFavorites.text = "No favorites"
            noFavorites.font = UIFont.systemFont(ofSize: 15, weight: UIFontWeightMedium)
            noFavorites.textColor = .lightGray
            noFavorites.textAlignment = .center
            view.addSubview(noFavorites)
            noFavorites.translatesAutoresizingMaskIntoConstraints = false
            noFavorites.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            noFavorites.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedWallpaperVC = segue.destination as? SelectedWallpaperViewController {
            if let wallpaperCollectionViewCell = sender as? WallpaperCell {
                selectedWallpaperVC.wallpaperImage = wallpaperCollectionViewCell.wallpaper.image
            }
        }
    }

}

extension FavoritesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteWallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallpaperCell", for: indexPath) as! WallpaperCell
        
        cell.tag = indexPath.row
        cell.title.text = favoriteWallpapers[indexPath.row].title
        cell.author.text = favoriteWallpapers[indexPath.row].author
        cell.wallpaper.image = UIImage(named: "gray")!
        
        if let wallpaperURL = URL(string: favoriteWallpapers[indexPath.row].fullResolutionURL)
        {
            wallpaperRequester.fetchWallpaperImage(from: wallpaperURL) { (wallpaper, error) in
                if cell.tag == indexPath.row {
                    if let wallpaper = wallpaper {
                        cell.wallpaper.image = wallpaper
                    }
                }
            }
        }

        
        return cell
    }
    
}


extension FavoritesViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Wallpaper", sender: collectionView.cellForItem(at: indexPath))
    }
    
}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.bounds.size.width - (Dimension.edgeInsets.left * 2)
        
        return CGSize(width: availableWidth, height: Dimension.cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return Dimension.edgeInsets
    }
    
}
