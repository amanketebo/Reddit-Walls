//
//  ViewController.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/17/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class WallpapersVC: UIViewController {
    @IBOutlet weak var collectionView: UICollectionView!
    let activityIndicator = UIActivityIndicatorView(style: .gray)

    var wallpapersDataSource = WallpapersDataSource()
    var wallpapersDelegate = WallpapersDelegate()
    let theme = Theme.shared
    let userDefaults = UserDefaults.standard
    let notificationCenter = NotificationCenter.default

    init(wallpaperDataSource: WallpapersDataSource) {
        super.init(nibName: nil, bundle: nil)
        self.wallpapersDataSource = wallpaperDataSource
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        addObservers()
        fetchWallpapers()
    }

    private func setupViews() {
        setBackgroundColors()

        collectionView.dataSource = wallpapersDataSource
        collectionView.delegate = wallpapersDelegate
        wallpapersDataSource.wallpapersVC = self
        wallpapersDelegate.wallpapersVC = self
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: Dimension.footerHeight, right: 0)
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshWallpapers), for: .valueChanged)

        view.addSubview(activityIndicator)
        activityIndicator.centerInParentView()
        activityIndicator.startAnimating()
    }

    private func addObservers() {
        notificationCenter.addObserver(self, selector: #selector(updateTheme), name: .themeUpdated, object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateFavoriteIcons), name: .favoritesUpdated, object: nil)
    }

    private func setBackgroundColors() {
        theme.styleBackground(view)
        theme.styleBackground(collectionView.subviews[0])
    }

    @objc private func updateTheme() {
        collectionView.reloadData()
        setBackgroundColors()
    }

    @objc private func updateFavoriteIcons() {
        collectionView.reloadData()
    }

    func fetchWallpapers() {
        wallpapersDataSource.fetchWallpapers { [weak self] (result) in
            guard let strongSelf = self else { return }

            switch result {
            case .success(let wallpapers):
                if strongSelf.wallpapersDataSource.currentPage == 0 {
                    strongSelf.wallpapersDataSource.wallpapers = wallpapers
                    strongSelf.collectionView.reloadData()
                } else {
                    let newIndexPaths: [IndexPath] = strongSelf.insertingIndexPaths(incomingWallpapers: wallpapers)

                    strongSelf.wallpapersDataSource.wallpapers += wallpapers
                    strongSelf.collectionView.performBatchUpdates({
                        strongSelf.collectionView.insertItems(at: newIndexPaths)
                    }, completion: nil)
                }
            case .failure(_):
                Alert.showNetworkErrorAlert(vc: strongSelf) {
                    strongSelf.collectionView.scrollRectToVisible(.zero, animated: true)
                }
            }

            strongSelf.stopRefreshing()
            strongSelf.wallpapersDataSource.initialFetch = false
        }
    }

    @objc private func refreshWallpapers() {
        wallpapersDataSource.currentPage = 0
        fetchWallpapers()
    }

    func stopRefreshing() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        collectionView.refreshControl?.endRefreshing()
    }

    @IBAction func segueToFavoritesView(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: UIStoryboard.favoritesSegue, sender: nil)
    }

    // MARK: - Helper methods

    func insertingIndexPaths(incomingWallpapers: [Wallpaper]) -> [IndexPath] {
        let currentWallpaperCount = wallpapersDataSource.wallpapers.count
        let newWallpaperCount = currentWallpaperCount + incomingWallpapers.count
        var newIndexPaths: [IndexPath] = []

        for index in currentWallpaperCount..<newWallpaperCount {
            let indexPath = IndexPath(row: index - 1, section: 0)
            newIndexPaths.append(indexPath)
        }

        return newIndexPaths
    }
}
