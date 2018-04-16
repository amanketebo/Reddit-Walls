//
//  RedditsVC.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 4/15/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import UIKit

class RedditsVC: UIViewController {
    @IBOutlet weak var redditsView: RedditsView!
    @IBOutlet weak var wallpapersView: UIView!

    let wallpapersVC = UIStoryboard.wallpapersVC(baseURL: "https://www.reddit.com/r/wallpapers.json")
    let iphoneWallpapersVC = UIStoryboard.wallpapersVC(baseURL: "https://www.reddit.com/r/iphonewallpapers.json")

    let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(updateRedditsViewTheme), name: .themeUpdated, object: nil)
        setupViews()
    }

    private func setupViews() {
        // Navigation bar setup
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)

        redditsView.delegate = self

        addChildViewController(wallpapersVC)
        wallpapersView.addSubview(wallpapersVC.view)
        wallpapersVC.view.fillSuperView()
        wallpapersVC.didMove(toParentViewController: self)

        addChildViewController(iphoneWallpapersVC)
        wallpapersView.addSubview(iphoneWallpapersVC.view)
        iphoneWallpapersVC.view.fillSuperView()
        iphoneWallpapersVC.didMove(toParentViewController: self)

        iphoneWallpapersVC.view.isHidden = true

        updateRedditsViewTheme()
    }

    @objc private func updateRedditsViewTheme() {
        Theme.shared.styleBackground(redditsView.underlineHolderView)
        Theme.shared.styleRedditViewsLabel(redditsView.wallpapersLabel)
        Theme.shared.styleRedditViewsLabel(redditsView.iphoneWallpapersLabel)
    }

    @IBAction func tappedFavorites(_ sender: UITapGestureRecognizer) {
        performSegue(withIdentifier: UIStoryboard.favoritesSegue, sender: nil)
    }
}

extension RedditsVC: RedditsViewDelegate {
    func redditsViewSelectionChanged(subreddit: Subreddit) {
        switch subreddit {
        case .wallpapers: iphoneWallpapersVC.view.isHidden = true
        case .iphoneWallpapers: iphoneWallpapersVC.view.isHidden = false
        }
    }
}
