//
//  WallpaperCell.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/19/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class WallpaperCell: UICollectionViewCell {
    
    static let wallpaperCell = "wallpaperCell"
    @IBOutlet weak var wallpaper: UIImageView!
    
    @IBOutlet weak var title: UILabel!
    
    @IBOutlet weak var author: UILabel!
    
    @IBOutlet weak var favoriteIcon: UIImageView!
    
}
