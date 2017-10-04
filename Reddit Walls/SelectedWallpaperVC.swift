//
//  SelectedWallpaperViewController.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/31/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit
import Photos

class SelectedWallpaperVC: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var wallpaper: UIImage!
    var imageView: UIImageView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        setupViews()
    }
    
    func setupViews()
    {
        // Navigation bar setup
        navigationItem.title = "Wallpaper"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveWallpaper))
        
        // Image view and scroll view setup
        imageView = UIImageView(image: wallpaper)
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
    }
    
    func saveWallpaper() {
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
            }
        })
    }
    
    private func saveImage()
    {
        UIImageWriteToSavedPhotosAlbum(wallpaper, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc private func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer)
    {
        if let error = error
        {
            // Show information vc telling user that there was a problem saving the image
        }
        else
        {
            // Show informationvc telling user that the image has been saved
        }
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
    }
}
