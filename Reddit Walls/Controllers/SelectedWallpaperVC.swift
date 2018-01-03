//
//  SelectedWallpaperViewController.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/31/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit
import Photos

extension UIActivityType {
    public static let customSaveToCameraRoll: UIActivityType =  UIActivityType(rawValue: "customSaveToCameraRoll")
}

class SelectedWallpaperVC: UIViewController {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButtonContainerView: UIView!
    
    var selectedWallpaper: Wallpaper!
    var wallpaperImage: UIImage!
    var imageView: UIImageView!
    var wallpaperHasLoaded = false
    let wallpaperRequester = WallpaperRequester.shared
    var hideCloseButton: Bool = false {
        didSet {
            closeButtonContainerView.isHidden = hideCloseButton
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .currentContext
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override func viewDidLayoutSubviews() {
        // Self note: This method is called when the autolayout engine has
        // finished calculating the subviews' frame
        setupViews()
    }
    
    func setupViews()
    {
        // Image view and scroll view setup
        if wallpaperHasLoaded
        {
            imageView = UIImageView(image: wallpaperImage)
            imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: Dimension.imageViewHeight)
            
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
        }
        else
        {
            let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
            
            view.addSubview(activityIndicator)
            activityIndicator.centerInParentView()
            activityIndicator.startAnimating()
            
            let fullResURL = URL(string: selectedWallpaper.fullResolutionURL)!
            wallpaperRequester.fetchWallpaperImage(from: fullResURL, completion: { [weak self] (wallpaper, error) in
                if let _ = error {
                    let message = "Whoops, looks like something is wrong with the network. Check your connection and try again."
                    let leftButton = ButtonData(title: "Okay", color: .black)
                    let informationVC = InformationVC(message: message, image: #imageLiteral(resourceName: "warning"), leftButtonData: leftButton, rightButtonData: nil)
                    
                    self?.present(informationVC, animated: true, completion: nil)
                }
                else {
                    self?.wallpaperImage = wallpaper!
                    self?.wallpaperHasLoaded = true
                    activityIndicator.stopAnimating()
                    self?.setupViews()
                }
            })
        }
    }
    
    private func presentActivityController() {
        let activityController = UIActivityViewController(activityItems: [wallpaperImage], applicationActivities: [CustomSaveToCameraRollActivity()])
        activityController.excludedActivityTypes = [.addToReadingList, .markupAsPDF, .openInIBooks, .postToVimeo, .saveToCameraRoll]
        activityController.completionWithItemsHandler = { [weak self] (activity, success, returnedItems, activityError) in
            if activity == .customSaveToCameraRoll {
                self?.saveWallpaper()
            }
        }
        
        present(activityController, animated: true, completion: nil)
    }
    
    @objc private func zoomIn(_ tapGesture: UITapGestureRecognizer)
    {
        let tapPoint = tapGesture.location(in: scrollView)
        
        if scrollView.zoomScale == 1
        {
            let rect = CGRect(x: tapPoint.x, y: tapPoint.y, width: 10, height: 10)
            scrollView.zoom(to: rect, animated: true)
        }
        else
        {
            let rect = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: imageView.bounds.size.height)
            scrollView.zoom(to: rect, animated: true)
        }
    }
        
    @objc func saveWallpaper() {
        if (PHPhotoLibrary.authorizationStatus() == PHAuthorizationStatus.authorized)
        {
            saveImage()
        }
        else
        {
            requestPhotoLibraryAccess()
        }
    }
    
    private func requestPhotoLibraryAccess()
    {
        PHPhotoLibrary.requestAuthorization({ [weak self] (status) in
            if PHAuthorizationStatus.authorized == status
            {
                self?.saveImage()
            }
            else if PHAuthorizationStatus.denied == status
            {
                // Show information vc telling user to change setting
                let message = "Please change Photo's access settings to be able to save wallpapers"
                let buttonData = ButtonData(title: "Okay", color: .black)
                let informationVC = InformationVC(message: message, image: #imageLiteral(resourceName: "warning"), leftButtonData: buttonData, rightButtonData: nil)
                self?.present(informationVC, animated: true, completion: nil)
            }
        })
    }
    
    private func saveImage()
    {
        UIImageWriteToSavedPhotosAlbum(wallpaperImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
        
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer)
    {
        if let _ = error
        {
            let message = "Please change Photo's access settings to be able to save wallpapers"
            let buttonData = ButtonData(title: "Okay", color: .black)
            let informationVC = InformationVC(message: message, image: UIImage(named: "warning"), leftButtonData: buttonData, rightButtonData: nil)
            present(informationVC, animated: true, completion: nil)
        }
        else
        {
            let message = "Wallpaper saved sucessfully!"
            let informationVC = InformationVC(message: message, image: #imageLiteral(resourceName: "check"), leftButtonData: nil, rightButtonData: nil)
            self.present(informationVC, animated: true) {
                let _ = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (_) in
                    UIView.animate(withDuration: 0.5, animations: {
                        informationVC.view.alpha = 0
                    }, completion: { (_) in
                        informationVC.dismiss(animated: false, completion: nil)
                    })
                })
            }
        }
    }
    
    @IBAction func longPresssed(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            presentActivityController()
        }
    }
    
    @IBAction func tappedCloseButton(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
}

extension SelectedWallpaperVC: UIScrollViewDelegate
{
    func viewForZooming(in scrollView: UIScrollView) -> UIView?
    {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView)
    {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
        
        if scrollView.zoomScale <= 1 {
            hideCloseButton = false
        } else {
            hideCloseButton = true
        }
    }
}
