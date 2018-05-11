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
    @IBOutlet weak var wallpapersScrollView: UIScrollView!

    let wallpapersVC = UIStoryboard.wallpapersVC(baseURL: "https://www.reddit.com/r/wallpapers.json")
    let iphoneWallpapersVC = UIStoryboard.wallpapersVC(baseURL: "https://www.reddit.com/r/iphonewallpapers.json")

    let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        notificationCenter.addObserver(self, selector: #selector(updateRedditsViewTheme), name: .themeUpdated, object: nil)
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        redditsView.delegate = self
        wallpapersScrollView.delegate = self
        wallpapersScrollView.isPagingEnabled = true
        updateRedditsViewTheme()
    }

    override func viewWillLayoutSubviews() {
        setupViews()
    }

    private func setupViews() {
        let width = wallpapersScrollView.bounds.width
        let height = wallpapersScrollView.bounds.height

        wallpapersScrollView.contentSize = CGSize(width: width * 2, height: height)

        addChildViewController(wallpapersVC)
        wallpapersVC.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        wallpapersScrollView.addSubview(wallpapersVC.view)
        wallpapersVC.didMove(toParentViewController: self)

        addChildViewController(iphoneWallpapersVC)
        iphoneWallpapersVC.view.frame = CGRect(x: width, y: 0, width: width, height: height)
        wallpapersScrollView.addSubview(iphoneWallpapersVC.view)
        iphoneWallpapersVC.didMove(toParentViewController: self)
    }

    @objc private func updateRedditsViewTheme() {
        Theme.shared.styleBackground(view)
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
        case .wallpapers: wallpapersScrollView.scrollToPage(page: 0, animated: true)
        case .iphoneWallpapers: wallpapersScrollView.scrollToPage(page: 1, animated: true)
        }
    }
}

extension RedditsVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width

        if page == 0 {
            redditsView.moveUnderlineView(direction: .left)
        } else {
            redditsView.moveUnderlineView(direction: .right)
        }
    }
}

extension UIScrollView {
    func scrollToPage(page: Int, animated: Bool) {
        let rect = CGRect(x: self.bounds.width * CGFloat(page), y: 0, width: self.bounds.width, height: self.bounds.height)

        scrollRectToVisible(rect, animated: animated)
    }
}
