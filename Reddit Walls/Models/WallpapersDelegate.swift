//
//  WallpapersDelegate.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 8/22/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit

class WallpapersDelegate: NSObject, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    weak var wallpapersVC: WallpapersVC?

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let wallpapersVC = wallpapersVC else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? WallpaperCell else { return }

        let selectedWallpaperVC = UIStoryboard.selectedWallpaperVC
        let selectedWallpaper = wallpapersVC.wallpapersDataSource.wallpapers[indexPath.row]

        selectedWallpaperVC.selectedWallpaper = selectedWallpaper
        selectedWallpaperVC.wallpaperImage = cell.wallpaper.image
        selectedWallpaperVC.wallpaperHasLoaded = cell.wallpaperHasLoaded
        selectedWallpaperVC.wallpaperRequester = wallpapersVC.wallpapersDataSource.wallpaperRequester

        wallpapersVC.present(selectedWallpaperVC, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let wallpapersVC = wallpapersVC else { return }

        if indexPath.row >= wallpapersVC.wallpapersDataSource.wallpapers.count {
            wallpapersVC.wallpapersDataSource.currentPage += 1
            wallpapersVC.fetchWallpapers()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let wallpapersVC = wallpapersVC else { return }
        guard indexPath.row < wallpapersVC.wallpapersDataSource.wallpapers.count else { return }
        let wallpaper = wallpapersVC.wallpapersDataSource.wallpapers[indexPath.row]
        guard let url = wallpaper.resolutions.full else { return }

        func isSameTask(_ task: URLSessionTask) -> Bool {
            if let taskURL = task.originalRequest?.url {
                return url.absoluteString == taskURL.absoluteString
            } else {
                return false
            }
        }

        URLSession.shared.getAllTasks { (tasks) in
            guard let taskIndex = tasks.firstIndex(where: { (task) -> Bool in return isSameTask(task) }) else { return }

            tasks[taskIndex].cancel()
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        guard let wallpapersVC = wallpapersVC else { return .zero}

        let availableWidth = wallpapersVC.view.bounds.size.width - (Dimension.edgeInsets.left * 2)

        return CGSize(width: availableWidth, height: Dimension.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Dimension.edgeInsets
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard let wallpapersVC = wallpapersVC else { return .zero }

        return CGSize(width: wallpapersVC.view.bounds.size.width, height: Dimension.footerHeight)
    }
}
