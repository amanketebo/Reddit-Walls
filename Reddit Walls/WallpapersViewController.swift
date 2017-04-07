//
//  ViewController.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/17/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

var appearCount = 0

class WallpapersViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var favoritesView: UIView!
    
    let dataManager = DataManager()
    var wallpaperInfos = [WallpaperInfo]()
    var wallpaperCache = [NSURL:UIImage]()
    var favoriteURLs = [NSURL]()
    
    let cellHeight:CGFloat = 275
    let edgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
    let footerHeight: CGFloat = 75
    let refreshControl = UIRefreshControl()
    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        navigationController?.navigationBar.isTranslucent = false
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        collectionView.delegate = self
        collectionView.dataSource = self
        setupViews()
        
        dataManager.getJSON(completion: {[weak self] (wallpaperInfos) in
            self?.wallpaperInfos = wallpaperInfos
            self?.activityIndicator.stopAnimating()
            self?.activityIndicator.removeFromSuperview()
            self?.collectionView.reloadData()
        })
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupViews() {
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: footerHeight, right: 0)
        refreshControl.backgroundColor = .hintOfGray
        refreshControl.addTarget(self, action: #selector(refresh(_:)), for: .valueChanged)
        collectionView.refreshControl = refreshControl
        
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    deinit {
        print("Dipped out: WallpapersViewController")
    }
    
    func refresh(_ refreshControl: UIRefreshControl) {
        dataManager.getJSON(completion: {[weak self] (wallpaperInfos) in
            self?.wallpaperInfos = wallpaperInfos
            self?.collectionView.reloadData()
            refreshControl.endRefreshing()
        })
    }
    
    @IBAction func tappedFavoritesView(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: "Favorites", sender: nil)
    }
    
    func tappedFavoritesIcon(_ sender: UITapGestureRecognizer) {
        if let wallpaperCollectionViewCell = sender.view?.superview?.superview as? WallpaperCollectionViewCell {
            let wallpaperPosition = wallpaperCollectionViewCell.tag
            
            if let wallpaperURL = NSURL(string: wallpaperInfos[wallpaperPosition].middleResolutionUrl) {
                if favoriteURLs.contains(wallpaperURL) {
                    wallpaperInfos[wallpaperPosition].favorite = false
                    favoriteURLs.remove(at: favoriteURLs.index(of: wallpaperURL)!)
                }
                else {
                    wallpaperInfos[wallpaperPosition].favorite = true
                    favoriteURLs.append(wallpaperURL)
                }
                
                collectionView.reloadData()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let selectedWallpaperVC = segue.destination as? SelectedWallpaperViewController {
            if let wallpaperCollectionViewCell = sender as? WallpaperCollectionViewCell {
               selectedWallpaperVC.wallpaper = wallpaperCollectionViewCell.wallpaper.image
            }
        }
        else if let favoritesVc = segue.destination as? FavoritesViewController {
            var favoriteWallpapers = [WallpaperInfo]()
            
            for wallpaper in wallpaperInfos {
                if wallpaper.favorite == true {
                    favoriteWallpapers.append(wallpaper)
                }
            }
            
            favoritesVc.dataManager = dataManager
            favoritesVc.favoriteWallpapers = favoriteWallpapers
            favoritesVc.wallpaperCache = wallpaperCache
            favoritesVc.edgeInsets = edgeInsets
            favoritesVc.cellHeight = cellHeight
        }
    }
    
}

extension WallpapersViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return wallpaperInfos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "wallpaperCell", for: indexPath) as! WallpaperCollectionViewCell
        
        // Set up cell
        cell.tag = indexPath.row
        cell.title.text = wallpaperInfos[indexPath.row].title
        cell.author.text = wallpaperInfos[indexPath.row].author
        cell.wallpaper.image = UIImage(named: "gray")!
        cell.favoriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tappedFavoritesIcon(_:))))
        
        // Set up favorite icon
        if let wallpaperURL = NSURL(string: wallpaperInfos[indexPath.row].middleResolutionUrl) {
            if favoriteURLs.contains(wallpaperURL) {
                cell.favoriteIcon.image = UIImage(named: "filledstar")!
            }
            else {
                cell.favoriteIcon.image = UIImage(named: "unfilledstar")!
            }
        }
        
        // Get wallpaper for cell
        if let wallpaperURL = URL(string: wallpaperInfos[indexPath.row].middleResolutionUrl) {
            let nsWallpaperURL = wallpaperURL as NSURL
            if let cachedImage = wallpaperCache[nsWallpaperURL] {
                cell.wallpaper.image = cachedImage
            }
            else {
                dataManager.getWallpaperForCell(from: wallpaperURL) {[weak self] (data) in
                    if cell.tag == indexPath.row {
                        if let wallpaper = UIImage(data: data) {
                            cell.wallpaper.image = wallpaper
                            self?.wallpaperCache[nsWallpaperURL] = wallpaper
                        }
                    }
                }
            }
        }
        
        // Change appearance of cell
        let bottomBorder = CALayer()
        bottomBorder.frame = CGRect(x: 0, y: cell.bounds.size.height - 1, width: cell.bounds.size.width, height: 1)
        bottomBorder.backgroundColor = UIColor.lightGray.cgColor
        cell.layer.addSublayer(bottomBorder)
        
        return cell
    }
    
}

extension WallpapersViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        performSegue(withIdentifier: "Wallpaper", sender: collectionView.cellForItem(at: indexPath))
    }
    
}

extension WallpapersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.bounds.size.width - (edgeInsets.left * 2)
        
        return CGSize(width: availableWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        return edgeInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        
        return CGSize(width: view.bounds.size.width, height: footerHeight)
    }
    
}

