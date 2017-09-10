//
//  ViewController.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/17/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

struct Segue
{
    static let wallpaper = "Wallpaper"
    static let favorites = "Favorites"
}

struct Dimension
{
    static let cellHeight: CGFloat = 275
    static let footerHeight: CGFloat = 75
    static let edgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
}

class WallpapersVC: UIViewController
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favoritesView: UIView!
    
    var wallpapers = [Wallpaper]()
    let wallpaperRequester = WallpaperRequester()
    let stuffManager = StuffManager.shared
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
        fetchWallpapers()
    }

    private func setupViews()
    {
        // Navigation bar setup
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        // Collection view setup
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshWallpapers), for: .valueChanged)
        
        // Activity indicator setup
        view.addSubview(activityIndicator)
        activityIndicator.centerInParentView()
        activityIndicator.startAnimating()
    }
    
    func fetchWallpapers()
    {
        wallpaperRequester.fetchWallpapers(completion: { [weak self] (wallpapers, error) in
            if let error = error
            {
                print(error.localizedDescription)
            }
            else
            {
                self?.wallpapers = wallpapers!
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                self?.collectionView.reloadData()
            }
        })
    }
    
    @objc private func refreshWallpapers()
    {
        fetchWallpapers()
    }
    
    @IBAction func segueToFavoritesView(_ sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: Segue.favorites, sender: nil)
    }
    
    func changeFavoriteStatus(_ sender: UITapGestureRecognizer)
    {
        guard let wallpaperCell = sender.view?.superview?.superview as? WallpaperCell else { return }
        
        let wallpaperCellTag = wallpaperCell.tag
        let selectedWallpaper = wallpapers[wallpaperCellTag]
        
        if stuffManager.favorites.contains(where: { (wallpaper) -> Bool in
            return selectedWallpaper == wallpaper
        })
        {
            selectedWallpaper.favorite = false
            stuffManager.remove(selectedWallpaper)
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
        if let selectedWallpaperVC = segue.destination as? SelectedWallpaperViewController
        {
            if let wallpaperCell = sender as? WallpaperCell
            {
               selectedWallpaperVC.wallpaperImage = wallpaperCell.wallpaper.image
            }
        }
    }
    
}

extension WallpapersVC: UICollectionViewDataSource
{
    func numberOfSections(in collectionView: UICollectionView) -> Int
    {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return wallpapers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell
    {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallpaperCell.wallpaperCell, for: indexPath) as! WallpaperCell
        let wallpaper = wallpapers[indexPath.row]
        
        // Set up cell
        cell.tag = indexPath.row
        cell.title.text = wallpaper.title
        cell.author.text = wallpaper.author
        cell.wallpaper.image = UIImage(named: "gray")!
        cell.favoriteIcon.image = UIImage(named: "unfilledstar")!
        cell.favoriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeFavoriteStatus(_:))))
        
        // Set up favorite icon
        if wallpaper.favorite
        {
            cell.favoriteIcon.image = UIImage(named: "filledstar")!
        }
        else
        {
            cell.favoriteIcon.image = UIImage(named: "unfilledstar")!
        }
        
        // Fetch wallpaper for cell
        if let wallpaperURL = URL(string: wallpapers[indexPath.row].fullResolutionURL)
        {
            wallpaperRequester.fetchWallpaperImage(from: wallpaperURL) { (data, error) in
                if let error = error
                {
                    print(error.localizedDescription)
                }
                else
                {
                    guard cell.tag == indexPath.row, let wallpaper = UIImage(data: data!) else { return }
                    
                    cell.wallpaper.image = wallpaper
                }
            }
        }
        
        return cell
    }
}

extension WallpapersVC: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath)
        
        performSegue(withIdentifier: Segue.wallpaper, sender: cell)
    }
}

extension WallpapersVC: UICollectionViewDelegateFlowLayout
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
        return CGSize(width: view.bounds.size.width, height: Dimension.footerHeight)
    }
}

