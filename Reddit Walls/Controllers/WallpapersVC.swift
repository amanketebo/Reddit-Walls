//
//  ViewController.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/17/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class WallpapersVC: BaseVC {
    @IBOutlet weak var collectionView: UICollectionView!

    var wallpapers = [Wallpaper]()
    let notificationCenter = NotificationCenter.default
    let userDefaults = UserDefaults.standard
    var currentPage = 0
    var initialFetch = true

    let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        notificationCenter.addObserver(self, selector: #selector(updateFavoriteIcons), name: .favoritesUpdated, object: nil)
        notificationCenter.addObserver(self, selector: #selector(updateTheme), name: .themeUpdated, object: nil)
        fetchWallpapers()
    }

    private func setupViews() {
        Theme.shared.styleBackground(collectionView.subviews[0])


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

    @objc func changeFavoriteStatus(_ sender: UITapGestureRecognizer) {
        guard let wallpaperCell = sender.view?.superview?.superview as? WallpaperCell else { return }

        let wallpaperCellTag = wallpaperCell.tag
        let indexPath = IndexPath(row: wallpaperCellTag, section: 0)
        let selectedWallpaper = wallpapers[wallpaperCellTag]

        if stuffManager.favoritesContains(selectedWallpaper) {
            selectedWallpaper.favorite = false
            stuffManager.removeFavorite(selectedWallpaper)
            collectionView.performBatchUpdates({
                if let wallpaperCell = collectionView.cellForItem(at: indexPath) as? WallpaperCell {
                    wallpaperCell.favoriteIcon.image = Theme.shared.favoriteIconImage(selected: false)
                }
            }, completion: nil)
        } else {
            selectedWallpaper.favorite = true
            stuffManager.favorites.append(selectedWallpaper)
            collectionView.performBatchUpdates({
                if let wallpaperCell = collectionView.cellForItem(at: indexPath) as? WallpaperCell {
                    wallpaperCell.favoriteIcon.image = Theme.shared.favoriteIconImage(selected: true)
                }
            }, completion: nil)
        }
    }

    @objc private func updateTheme() {
        collectionView.reloadData()
        Theme.shared.styleBackground(collectionView.subviews[0])
    }

    func fetchWallpapers() {
        wallpaperRequester.fetchWallpapers(page: currentPage, completion: { [weak self] (wallpapers, error) in

            if error != nil {
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
            } else {
                if self?.currentPage == 0 {
                    self?.wallpapers = wallpapers!
                    self?.collectionView.reloadData()
                } else {
                    let previousWallpaperCount = self!.wallpapers.count
                    let currentWallpaperCount = previousWallpaperCount + wallpapers!.count
                    var newIndexPaths: [IndexPath] = []
                    for index in previousWallpaperCount..<currentWallpaperCount {
                        newIndexPaths.append(IndexPath(row: index - 1, section: 0))
                    }

                    self?.wallpapers += wallpapers!

                    self?.collectionView.performBatchUpdates({ [weak self] in
                        self?.collectionView.insertItems(at: newIndexPaths)
                        }, completion: { (_) in

                    })
                }

                self?.activityIndicator.stopAnimating()
                self?.activityIndicator.removeFromSuperview()
                self?.collectionView.refreshControl?.endRefreshing()
                self?.initialFetch = false
            }
        })
    }

    @objc private func updateFavoriteIcons() {
        collectionView.reloadData()
    }

    @objc private func refreshWallpapers() {
        currentPage = 0
        fetchWallpapers()
    }

    @IBAction func segueToFavoritesView(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: UIStoryboard.favoritesSegue, sender: nil)
    }
}

extension WallpapersVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let selectedWallpaperVC = UIStoryboard.selectedWallpaper.instantiateInitialViewController() as? SelectedWallpaperVC else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? WallpaperCell else { return }

        let associatedWallpaper = wallpapers[indexPath.row]

        selectedWallpaperVC.wallpaperImage = cell.wallpaper.image
        selectedWallpaperVC.selectedWallpaper = associatedWallpaper
        selectedWallpaperVC.wallpaperHasLoaded = cell.wallpaperHasLoaded

        present(selectedWallpaperVC, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row >= wallpapers.count {
            currentPage += 1
            fetchWallpapers()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard indexPath.row < wallpapers.count else { return }
        guard let url = URL(string: wallpapers[indexPath.row].fullResolutionURL) else { return }

        URLSession.shared.getAllTasks { (tasks) in
            guard let taskIndex = tasks.index(where: { (task) -> Bool in
                return url == task.originalRequest?.url
            }) else { return }

            tasks[taskIndex].cancel()
        }
    }
}

extension WallpapersVC: UICollectionViewDelegateFlowLayout {
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
}

extension WallpapersVC: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if initialFetch {
            return wallpapers.count
        } else if !initialFetch && wallpaperRequester.nextPage == nil {
            return wallpapers.count
        } else {
            return wallpapers.count + 1
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < wallpapers.count {
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallpaperCell.identifier, for: indexPath) as! WallpaperCell
            // swiftlint:disable:previous force_cast
            let savedTheme = userDefaults.integer(forKey: UserDefaults.themeKey)
            let theme = AppTheme(rawValue: savedTheme)

            setupCollectionView(cell: cell, indexPath: indexPath, wallpapers: wallpapers, theme: theme)
            cell.favoriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeFavoriteStatus(_:))))

            return cell
        } else {
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LoadingCell.identifier, for: indexPath) as! LoadingCell
            // swiftlint:disable:previous force_cast

            setupCollectionView(cell: cell)

            return cell
        }
    }
}
