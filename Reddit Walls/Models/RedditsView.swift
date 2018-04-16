//
//  RedditsView.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 4/14/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import UIKit

enum Direction {
    case left
    case right
}

enum Subreddit {
    case wallpapers
    case iphoneWallpapers
}

protocol RedditsViewDelegate: NSObjectProtocol {
    func redditsViewSelectionChanged(subreddit: Subreddit)
}

@IBDesignable
class RedditsView: UIView {
    @IBOutlet weak var wallpapersLabel: UILabel!
    @IBOutlet weak var iphoneWallpapersLabel: UILabel!
    @IBOutlet weak var underlineHolderView: UIView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var sameWidthConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    var trailingConstraint: NSLayoutConstraint!

    weak var delegate: RedditsViewDelegate?

    var firstTap = true

    override func awakeFromNib() {
        layer.shadowOffset = CGSize(width: 1, height: 1)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 2
        layer.shadowOpacity = 0.3
    }

    @IBAction func tappedWallpapers(_ sender: UITapGestureRecognizer) {
        moveUnderlineView(direction: .left)
        delegate?.redditsViewSelectionChanged(subreddit: .wallpapers)
    }

    @IBAction func tappedIphoneWallpapers(_ sender: UITapGestureRecognizer) {
        moveUnderlineView(direction: .right)
        delegate?.redditsViewSelectionChanged(subreddit: .iphoneWallpapers)
    }

    // Maybe just use a view and animates its frame
    // Working with these constraints is sorta weird
    func moveUnderlineView(direction: Direction) {
        let labelWidth = wallpapersLabel.bounds.width

        if firstTap {
            sameWidthConstraint.isActive = false
        }

        switch direction {
        case .left:
            leadingConstraint.constant = 0

            if firstTap {
                trailingConstraint = underlineView.rightAnchor.constraint(equalTo: underlineHolderView.rightAnchor, constant: -labelWidth)
                trailingConstraint.isActive = true
            } else {
                trailingConstraint.constant = -labelWidth
            }
        case .right:
            leadingConstraint.constant = labelWidth

            if firstTap {
                trailingConstraint = underlineView.rightAnchor.constraint(equalTo: underlineHolderView.rightAnchor)
                trailingConstraint.isActive = true
            } else {
                trailingConstraint.constant = 0
            }
        }

        UIView.animate(withDuration: 0.2) { [weak self] in
            self?.layoutIfNeeded()
        }

        if firstTap {
            firstTap = false
        }
    }
}
