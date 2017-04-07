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
    
    var dataManager: DataManager!
    var favoriteWallpapers = [WallpaperInfo]()
    var wallpaperCache: [NSURL:UIImage]!
    var cellHeight: CGFloat!
    var edgeInsets: UIEdgeInsets!
    
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
            if let wallpaperCollectionViewCell = sender as? WallpaperCollectionViewCell {
                selectedWallpaperVC.wallpaper = wallpaperCollectionViewCell.wallpaper.image
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallpaperCell", for: indexPath) as! WallpaperCollectionViewCell
        
        cell.tag = indexPath.row
        cell.title.text = favoriteWallpapers[indexPath.row].title
        cell.author.text = favoriteWallpapers[indexPath.row].author
        cell.wallpaper.image = UIImage(named: "gray")!
        
        
        if let wallpaperURL = URL(string: favoriteWallpapers[indexPath.row].middleResolutionUrl) {
            let nsWallpaperURL = wallpaperURL as NSURL
            if let cachedImage = wallpaperCache[nsWallpaperURL] {
                cell.wallpaper.image = cachedImage
            }
            else {
                dataManager.getWallpaperForCell(from: wallpaperURL) { (data) in
                    if cell.tag == indexPath.row {
                        if let wallpaper = UIImage(data: data) {
                            cell.wallpaper.image = wallpaper
                            self.wallpaperCache[nsWallpaperURL] = wallpaper
                        }
                    }
                }
            }
        }
        
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: cell.bounds.size.height - 1, width: cell.bounds.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        cell.layer.addSublayer(bottomBorder)
        
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
        let availableWidth = view.bounds.size.width - (edgeInsets.left * 2)
        
        return CGSize(width: availableWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return edgeInsets
    }
    
}
