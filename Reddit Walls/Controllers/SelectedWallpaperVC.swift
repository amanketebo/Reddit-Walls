//
//  SelectedWallpaperViewController.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/31/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit
import Photos

extension UIActivity.ActivityType {
    public static let customSaveToCameraRoll: UIActivity.ActivityType =  UIActivity.ActivityType(rawValue: "customSaveToCameraRoll")
}

class SelectedWallpaperVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButtonContainerView: UIView!
    @IBOutlet var panGestureRecognizer: UIPanGestureRecognizer!
    @IBOutlet weak var xButtonContainerConstraint: NSLayoutConstraint!

    var selectedWallpaper: Wallpaper!
    var wallpaperImage: UIImage!
    var imageView: UIImageView!
    var wallpaperHasLoaded = false
    var wallpaperFetcher: WallpaperFetching!
    var hideCloseButton: Bool = false {
        didSet {
            closeButtonContainerView.isHidden = hideCloseButton
        }
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overCurrentContext
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if UIDevice().userInterfaceIdiom == .phone && UIScreen.main.nativeBounds.height == 2436 {
            xButtonContainerConstraint.constant = 40
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }

    override func viewDidLayoutSubviews() {
        // Self note: This method is called when the autolayout engine has
        // finished calculating the subviews' frame
        setupViews()
    }

    func setupViews() {
        // Image view and scroll view setup
        if wallpaperHasLoaded {
            // Calculate height make sure to keep the aspect ratio
            let height = (wallpaperImage.size.height / wallpaperImage.size.width) * view.bounds.width
            imageView = UIImageView(image: wallpaperImage)
            imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: height)

            let padding = (scrollView.bounds.size.height - imageView.frame.size.height) / 2

            scrollView.contentSize = imageView.bounds.size
            scrollView.addSubview(imageView)

            scrollView.delegate = self
            scrollView.showsVerticalScrollIndicator = false
            scrollView.showsHorizontalScrollIndicator = false

            scrollView.minimumZoomScale = 1
            scrollView.maximumZoomScale = 3
            scrollView.contentInset = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)

            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(zoomIn(_:)))

            tapGestureRecognizer.numberOfTapsRequired = 2
            view.addGestureRecognizer(tapGestureRecognizer)
        } else {
            let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)

            view.addSubview(activityIndicator)
            activityIndicator.centerInParentView()
            activityIndicator.startAnimating()
            wallpaperFetcher.fetchImage(forWallpaper: selectedWallpaper,
                                        usingResolution: .full,
                                        completionQueue: .main) { [weak self] result in
                switch result {
                case .success(let wallpaper):
                    self?.wallpaperImage = wallpaper
                    self?.wallpaperHasLoaded = true
                    activityIndicator.stopAnimating()
                    self?.setupViews()
                case .failure(_):
                    let message = "Whoops, looks like something is wrong with the network. Check your connection and try again."
                    let okayButton = Button.okayButton
                    let informationVC = InformationVC(message: message, image: #imageLiteral(resourceName: "warning"), buttons: [okayButton], autoFadeOut: false)
                    
                    self?.present(informationVC, animated: true, completion: nil)
                }
            }
        }
    }

    private func presentActivityController() {
        let activityController = UIActivityViewController(activityItems: [wallpaperImage as Any], applicationActivities: [CustomSaveToCameraRollActivity()])
        
        activityController.excludedActivityTypes = [.addToReadingList, .markupAsPDF, .openInIBooks, .postToVimeo, .saveToCameraRoll]
        activityController.completionWithItemsHandler = { [weak self] (activity, success, returnedItems, activityError) in
            if activity == .customSaveToCameraRoll {
                self?.saveWallpaper()
            }
        }

        present(activityController, animated: true, completion: nil)
    }

    @objc private func zoomIn(_ tapGesture: UITapGestureRecognizer) {
        let tapPoint = tapGesture.location(in: scrollView)

        if scrollView.zoomScale == 1 {
            let rect = CGRect(x: tapPoint.x, y: tapPoint.y, width: 10, height: 10)
            scrollView.zoom(to: rect, animated: true)
        } else {
            let rect = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: imageView.bounds.size.height)
            scrollView.zoom(to: rect, animated: true)
        }
    }

    @objc func saveWallpaper() {
        if PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized {
            saveImage()
        } else {
            requestPhotoLibraryAccess()
        }
    }

    private func requestPhotoLibraryAccess() {
        PHPhotoLibrary.requestAuthorization({ [weak self] (status) in
            guard let strongSelf = self else { return }

            if PHAuthorizationStatus.authorized == status {
                self?.saveImage()
            } else if PHAuthorizationStatus.denied == status {
                // Show information vc telling user to change setting
                Alert.showPhotosAccessError(vc: strongSelf)
            }
        })
    }

    private func saveImage() {
        UIImageWriteToSavedPhotosAlbum(wallpaperImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }

    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer) {
        if error != nil {
            Alert.showPhotosAccessError(vc: self)
        } else {
            Alert.showWallpaperSaveSuccess(vc: self)
        }
    }

    @IBAction func longPresssed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            presentActivityController()
        }
    }

    @IBAction func panned(_ sender: UIPanGestureRecognizer) {
        switch sender.state {
        case .began:
            hideCloseButton = true
        case .changed:
            let panTranslation = sender.translation(in: scrollView).y
            let viewAlpha = 1 - abs(panTranslation / scrollView.bounds.height)

            view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: CGFloat(viewAlpha))
            scrollView.frame.origin.y = sender.translation(in: scrollView).y
        case .ended:
            let velocity = abs(Double(sender.velocity(in: view).y))
            let movingUpwards = sender.velocity(in: view).y < 0 ? true : false

            if velocity > 100 {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    guard let strongSelf = self else { return }

                    if movingUpwards {
                        strongSelf.scrollView.frame.origin.y = -(strongSelf.view.bounds.height)
                    } else {
                        strongSelf.scrollView.frame.origin.y = strongSelf.view.bounds.height
                    }

                    strongSelf.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
                    }, completion: { [weak self] (_) in
                        guard let strongSelf = self else { return }

                        strongSelf.dismiss(animated: false, completion: nil)
                })
            } else {
                UIView.animate(withDuration: 0.3, animations: { [weak self] in
                    self?.scrollView.frame.origin.y = 0
                    self?.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 1)
                })

                hideCloseButton = false
            }
        default: break
        }
    }
    @IBAction func tappedCloseButton(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectedWallpaperVC: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }

    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size

        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0

        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)

        if scrollView.zoomScale <= 1 {
            hideCloseButton = false
            panGestureRecognizer.isEnabled = true
            var status = self.prefersStatusBarHidden
            status.toggle()
        } else {
            hideCloseButton = true
            panGestureRecognizer.isEnabled = false
            var status = self.prefersStatusBarHidden
            status.toggle()
        }
    }
}
