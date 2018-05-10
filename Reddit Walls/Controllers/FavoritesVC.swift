//
//  FavoritesVC.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class FavoritesVC: BaseVC {
    @IBOutlet weak var collectionView: UICollectionView!

    let notificationCenter = NotificationCenter.default
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        Theme.shared.styleBackground(collectionView.subviews[0])
        Theme.shared.styleBackground(view)

        // Navigation bar setup
        navigationItem.title = "Favorites"

        // Collection view setup
        collectionView.dataSource = self
        collectionView.delegate = self
    }

    @objc func changeFavoriteStatus(_ sender: UITapGestureRecognizer) {
        guard let wallpaperCell = sender.view?.superview?.superview as? WallpaperCell else { return }

        let wallpaperCellTag = wallpaperCell.tag
        let selectedWallpaper = stuffManager.favorites[wallpaperCellTag]

        if stuffManager.favoritesContains(selectedWallpaper) {
            selectedWallpaper.favorite = false
            stuffManager.removeFavorite(selectedWallpaper)
        } else {
            selectedWallpaper.favorite = true
            stuffManager.favorites.append(selectedWallpaper)
        }

        collectionView.reloadData()
        notificationCenter.post(name: .favoritesUpdated, object: nil)
    }

    func setBackgroundColors() {
        Theme.shared.styleBackground(view)
        Theme.shared.styleBackground(collectionView.subviews[0])
    }
}

extension FavoritesVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = collectionView.cellForItem(at: indexPath) as? WallpaperCell else { return }
        guard stuffManager.favorites.count > 0 else { return }

        let associatedWallpaper = stuffManager.favorites[indexPath.row]

        if let selectedWallpaperVC = UIStoryboard.selectedWallpaper.instantiateInitialViewController() as? SelectedWallpaperVC {
            selectedWallpaperVC.wallpaperImage = cell.wallpaper.image
            selectedWallpaperVC.selectedWallpaper = associatedWallpaper
            selectedWallpaperVC.wallpaperHasLoaded = cell.wallpaperHasLoaded

            present(selectedWallpaperVC, animated: true, completion: nil)
        }
    }
}

extension FavoritesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableWidth = view.bounds.size.width - (Dimension.edgeInsets.left * 2)

        return CGSize(width: availableWidth, height: Dimension.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Dimension.edgeInsets
    }
}

extension FavoritesVC: UICollectionViewDataSource {

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if stuffManager.favorites.count == 0 {
            return 1
        } else {
            return stuffManager.favorites.count
        }
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if stuffManager.favorites.count != 0 {
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: WallpaperCell.identifier, for: indexPath) as! WallpaperCell
            // swiftlint:disable:previous force_cast

            let savedTheme = userDefaults.integer(forKey: UserDefaults.themeKey)
            let theme = AppTheme(rawValue: savedTheme)

            setupCollectionView(cell: cell, indexPath: indexPath, wallpapers: stuffManager.favorites, theme: theme)
            cell.favoriteIcon.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(changeFavoriteStatus(_:))))

            return cell
        } else {
            // swiftlint:disable:next force_cast
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NoFavoritesCell.identifier, for: indexPath) as! NoFavoritesCell
            //swiftlint:disable:previous force_cast

            setupCollectionView(noFavoritesCell: cell)

            return cell
        }
    }
}
