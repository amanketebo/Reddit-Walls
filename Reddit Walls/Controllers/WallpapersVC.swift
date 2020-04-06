//
//  ViewController.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/17/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class WallpapersVC: UIViewController,
                    UICollectionViewDataSource,
                    UICollectionViewDelegate,
                    UICollectionViewDelegateFlowLayout {
    
    enum Constants {
        static let edgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 75, right: 0)
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - Properties
    
    var wallpaperType: WallpaperType?
    var wallpaperFetcher: WallpaperFetching?
    var wallpapers: [Wallpaper] = []
    
    var currentPage = 0
    var isInitialFetch = true
    let activityIndicator = UIActivityIndicatorView(style: .gray)
    
    let theme = Theme.shared
    let notificationCenter = NotificationCenter.default

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWallpaperFetcher()
        setUpCollectionView()
        setUpActivityIndicator()
        setUpBackgroundColors()
        addObservers()
        fetchWallpapers()
    }
    
    // MARK: Set up
    
    private func setUpWallpaperFetcher() {
        guard let wallpaperType = wallpaperType else {
            assertionFailure("We should have a wallpaperType before this method is called.")
            return
        }
        
        wallpaperFetcher = wallpaperType.fetcher
    }
    
    private func setUpCollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.scrollIndicatorInsets = Constants.edgeInsets
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(refreshWallpapers),
                                                 for: .valueChanged)
    }

    private func setUpActivityIndicator() {
        view.addSubview(activityIndicator)
        activityIndicator.centerInParentView()
        activityIndicator.startAnimating()
    }
    
    private func setUpBackgroundColors() {
        theme.styleBackground(view)
        theme.styleBackground(collectionView.subviews[0])
    }
    
    private func addObservers() {
        notificationCenter.addObserver(self, selector: #selector(updateTheme), name: .themeUpdated, object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateFavoriteIcons), name: .favoritesUpdated, object: nil)
    }
    
    // MARK: Fetching

    func fetchWallpapers() {
        wallpaperFetcher?.fetchWallpapers(forPage: currentPage,
                                          completionQueue: .main,
                                          completion: { [weak self] result in
            guard let self = self else {
                return
            }
                                            
            switch result {
            case .success(let wallpapersResponse):
                if self.currentPage == 0 {
                    self.wallpapers = wallpapersResponse.wallpapers
                    self.collectionView.reloadData()
                } else {
                    let newIndexPaths: [IndexPath] = self.insertingIndexPaths(incomingWallpapers: wallpapersResponse.wallpapers)

                    self.wallpapers += wallpapersResponse.wallpapers
                    self.collectionView.performBatchUpdates({
                        self.collectionView.insertItems(at: newIndexPaths)
                    }, completion: nil)
                }
            case .failure(_):
                Alert.showNetworkErrorAlert(vc: self) {
                    self.collectionView.scrollRectToVisible(.zero, animated: true)
                }
            }

            self.stopRefreshing()
            self.isInitialFetch = false
        })
    }
    
    @objc private func refreshWallpapers() {
        currentPage = 0
        fetchWallpapers()
    }
    
    func stopRefreshing() {
        activityIndicator.stopAnimating()
        activityIndicator.removeFromSuperview()
        collectionView.refreshControl?.endRefreshing()
    }
    
    // MARK: - Updating
    
    @objc private func updateTheme() {
        collectionView.reloadData()
        setUpBackgroundColors()
    }

    @objc private func updateFavoriteIcons() {
        collectionView.reloadData()
    }
    
    // MARK: - Navigating

    @IBAction func segueToFavoritesView(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: UIStoryboard.favoritesSegue, sender: nil)
    }
    
    // MARK: - DataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isInitialFetch || (!isInitialFetch && currentPage == 0) {
            return wallpapers.count
        } else {
            return wallpapers.count + 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < wallpapers.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallpaperCell.identifier, for: indexPath) as! WallpaperCell
            let wallpaper = wallpapers[indexPath.row]
//            let isFavorite = favoritesManager.favorites.contains(wallpaper)
//            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(updateFavorite(_:)))

            theme.styleWallpaperCell(cell)
            cell.setup(wallpaper, at: indexPath)
//            cell.favoriteIcon.image = theme.favoriteIconImage(selected: isFavorite)
//            cell.favoriteIcon.addGestureRecognizer(tapGestureRecognizer)
//            fetchWallpaper(wallpaper, for: cell)

            return cell
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell

            theme.styleLoadingCell(cell)

            return cell
        }
    }
    
    // MARK: - Delegate
    
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //        guard let wallpapersVC = wallpapersVC else { return }
    //        guard let cell = collectionView.cellForItem(at: indexPath) as? WallpaperCell else { return }
    //
    //        let selectedWallpaperVC = UIStoryboard.selectedWallpaperVC
    //        let selectedWallpaper = wallpapersVC.wallpapersDataSource.wallpapers[indexPath.row]
    //
    //        selectedWallpaperVC.selectedWallpaper = selectedWallpaper
    //        selectedWallpaperVC.wallpaperImage = cell.wallpaper.image
    //        selectedWallpaperVC.wallpaperHasLoaded = cell.wallpaperHasLoaded
    //        selectedWallpaperVC.wallpaperFetcher = wallpapersVC.wallpapersDataSource.wallpaperFetcher
    //
    //        wallpapersVC.present(selectedWallpaperVC, animated: true, completion: nil)
        }

        func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        guard let wallpapersVC = wallpapersVC else { return }
    //
    //        if indexPath.row >= wallpapersVC.wallpapersDataSource.wallpapers.count {
    //            wallpapersVC.wallpapersDataSource.currentPage += 1
    //            wallpapersVC.fetchWallpapers()
    //        }
        }

        func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
    //        guard let wallpapersVC = wallpapersVC else { return }
    //        guard indexPath.row < wallpapersVC.wallpapersDataSource.wallpapers.count else { return }
    //        let wallpaper = wallpapersVC.wallpapersDataSource.wallpapers[indexPath.row]
    //        guard let url = wallpaper.resolutions.full else { return }
    //
    //        func isSameTask(_ task: URLSessionTask) -> Bool {
    //            if let taskURL = task.originalRequest?.url {
    //                return url.absoluteString == taskURL.absoluteString
    //            } else {
    //                return false
    //            }
    //        }
    //
    //        URLSession.shared.getAllTasks { (tasks) in
    //            guard let taskIndex = tasks.firstIndex(where: { (task) -> Bool in return isSameTask(task) }) else { return }
    //
    //            tasks[taskIndex].cancel()
    //        }
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let availableWidth = view.bounds.size.width - (Dimension.edgeInsets.left * 2)

            return CGSize(width: availableWidth, height: Dimension.cellHeight)
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
            return Dimension.edgeInsets
        }

        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
            return CGSize(width: view.bounds.size.width, height: Dimension.footerHeight)
        }

    // MARK: - Helpers

    func insertingIndexPaths(incomingWallpapers: [Wallpaper]) -> [IndexPath] {
        let currentWallpaperCount = wallpapers.count
        let newWallpaperCount = currentWallpaperCount + incomingWallpapers.count
        var newIndexPaths: [IndexPath] = []

        for index in currentWallpaperCount..<newWallpaperCount {
            let indexPath = IndexPath(row: index - 1, section: 0)
            newIndexPaths.append(indexPath)
        }

        return newIndexPaths
    }
}
