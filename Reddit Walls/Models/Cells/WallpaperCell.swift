//
//  WallpaperCell.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class WallpaperCell: UICollectionViewCell {
    @IBOutlet weak var wallpaper: UIImageView!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var submittedByLabel: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var favoriteIcon: UIImageView!
    @IBOutlet weak var seperator: UIView!

    var wallpaperHasLoaded = false

    static let identifier = "wallpaperCell"

    func setup(_ wallpaper: Wallpaper, at indexPath: IndexPath) {
        self.tag = indexPath.row
        self.title.text = wallpaper.title
        self.author.text = wallpaper.author
        self.wallpaper.image = #imageLiteral(resourceName: "gray")
    }
}
