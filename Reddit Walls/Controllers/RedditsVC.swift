//
//  RedditsVC.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 4/15/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import UIKit

class RedditsVC: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var redditsView: RedditsView!
    @IBOutlet weak var wallpapersScrollView: UIScrollView!

    // MARK: - Properties
    
    var desktopWallpapersViewController: WallpapersVC?
    var iPhoneWallpapersViewController: WallpapersVC?
    
    let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpWallpapersViewControllers()
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
    
    private func setUpWallpapersViewControllers() {
        self.desktopWallpapersViewController = UIStoryboard.wallpapersVC()
        self.desktopWallpapersViewController?.wallpaperType = .desktop
        
        self.iPhoneWallpapersViewController = UIStoryboard.wallpapersVC()
        self.iPhoneWallpapersViewController?.wallpaperType = .mobile
    }

    private func setupViews() {
        guard let desktopWallpapersViewController = desktopWallpapersViewController,
            let iPhoneWallpapersViewController = iPhoneWallpapersViewController else {
                assertionFailure("We should have both view controllers set up before this method is called")
                return
        }
        
        let width = wallpapersScrollView.bounds.width
        let height = wallpapersScrollView.bounds.height

        wallpapersScrollView.contentSize = CGSize(width: width * 2, height: height)

        addChild(desktopWallpapersViewController)
        desktopWallpapersViewController.view.frame = CGRect(x: 0, y: 0, width: width, height: height)
        wallpapersScrollView.addSubview(desktopWallpapersViewController.view)
        desktopWallpapersViewController.didMove(toParent: self)

        addChild(iPhoneWallpapersViewController)
        iPhoneWallpapersViewController.view.frame = CGRect(x: width, y: 0, width: width, height: height)
        wallpapersScrollView.addSubview(iPhoneWallpapersViewController.view)
        iPhoneWallpapersViewController.didMove(toParent: self)
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
