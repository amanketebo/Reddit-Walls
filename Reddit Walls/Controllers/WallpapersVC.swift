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
    static let imageViewHeight: CGFloat = 215
}

extension Notification.Name {
    static let favoritesUpdated = Notification.Name(rawValue: "favoritesUpdated")
}

class WallpapersVC: BaseVC
{
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var favoritesView: UIView!
    
    var wallpapers = [Wallpaper]()
    let notificationCenter = NotificationCenter.default
    
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        setupViews()
        notificationCenter.addObserver(self, selector: #selector(reloadFavorites), name: .favoritesUpdated, object: nil)
        fetchWallpapers()
    }

    private func setupViews()
    {
        // Navigation bar setup
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        // Collection view setup
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: Dimension.footerHeight, right: 0)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshWallpapers), for: .valueChanged)
        
        // Activity indicator setup
        view.addSubview(activityIndicator)
        activityIndicator.centerInParentView()
        activityIndicator.startAnimating()
    }
    
    func changeFavoriteStatus(_ sender: UITapGestureRecognizer)
    {
        guard let wallpaperCell = sender.view?.superview?.superview as? WallpaperCell else { return }
        
        let wallpaperCellTag = wallpaperCell.tag
        let indexPath = IndexPath(row: wallpaperCellTag, section: 0)
        let selectedWallpaper = wallpapers[wallpaperCellTag]
        
        if stuffManager.favoritesContains(selectedWallpaper)
        {
            selectedWallpaper.favorite = false
            stuffManager.removeFavorite(selectedWallpaper)
            collectionView.performBatchUpdates({
                if let wallpaperCell = collectionView.cellForItem(at: indexPath) as? WallpaperCell
                {
                    wallpaperCell.favoriteIcon.image = #imageLiteral(resourceName: "unfilledstar")
                }
            }, completion: nil)
        }
        else
        {
            selectedWallpaper.favorite = true
            stuffManager.favorites.append(selectedWallpaper)
            collectionView.performBatchUpdates({
                if let wallpaperCell = collectionView.cellForItem(at: indexPath) as? WallpaperCell
                {
                    wallpaperCell.favoriteIcon.image = #imageLiteral(resourceName: "filledstar")
                }
            }, completion: nil)
        }
    }
    
    func fetchWallpapers()
    {
        wallpaperRequester.fetchWallpapers(completion: { [weak self] (wallpapers, error) in
            if let _ = error
            {
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                self?.collectionView.refreshControl?.endRefreshing()
                
                let message = "Whoops, looks like something is wrong with the network. Check your connection and try again."
                let leftButton = ButtonData(title: "Okay", color: .black)
                let informationVC = InformationVC(message: message, image: #imageLiteral(resourceName: "warning"), leftButtonData: leftButton, rightButtonData: nil)
                
                self?.present(informationVC, animated: true, completion: { [weak self] in
                    self?.activityIndicator.stopAnimating()
                    self?.activityIndicator.removeFromSuperview()
                    self?.collectionView.refreshControl?.endRefreshing()
                    self?.collectionView.scrollRectToVisible(CGRect(), animated: true)
                })
            }
            else
            {
                self?.wallpapers = wallpapers!
                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                self?.collectionView.refreshControl?.endRefreshing()
                self?.collectionView.reloadData()
            }
        })
    }
    
    @objc private func reloadFavorites()
    {
        collectionView.reloadData()
    }
    
    @objc private func refreshWallpapers()
    {
        fetchWallpapers()
    }
    
    @IBAction func segueToFavoritesView(_ sender: UITapGestureRecognizer)
    {
        performSegue(withIdentifier: Segue.favorites, sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Following code is only for when you are seguing to SelctedWallpaperVC
        if let selectedWallpaperVC = segue.destination as? SelectedWallpaperVC
        {
            if let tuple = sender as? (cell: WallpaperCell, associatedWallpaper: Wallpaper)
            {
                selectedWallpaperVC.wallpaper = tuple.cell.wallpaper.image
                selectedWallpaperVC.wallpaperHasLoaded = tuple.cell.wallpaperHasLoaded
                selectedWallpaperVC.selectedWallpaper = tuple.associatedWallpaper
            }
        }
    }
    
}

extension WallpapersVC: UICollectionViewDelegate
{
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
    {
        let cell = collectionView.cellForItem(at: indexPath)
        let associatedWallpaper = wallpapers[indexPath.row]
        
        performSegue(withIdentifier: Segue.wallpaper, sender: (cell, associatedWallpaper))
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallpaperCell.identifier, for: indexPath) as! WallpaperCell
        
        setupCollectionView(cell: cell, indexPath: indexPath, wallpapers: wallpapers)
        cell.favoriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeFavoriteStatus(_:))))
        
        return cell
    }
}

