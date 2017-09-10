//
//  SelectedWallpaperViewController.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/31/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

class SelectedWallpaperViewController: UIViewController {
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var wallpaperImage: UIImage!
    var imageView: UIImageView!
    let imageViewHeight: CGFloat = 250
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        navigationItem.title = "Wallpaper"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(saveImage(_:)))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        scrollView.delegate = self
        imageView = UIImageView(image: wallpaperImage)
        imageView.frame = CGRect(x: 0, y: 0, width: view.bounds.size.width, height: imageViewHeight)
        scrollView.contentSize = imageView.bounds.size
        scrollView.addSubview(imageView)
        
        let padding = (scrollView.bounds.size.height - imageView.frame.size.height) / 2
        
        scrollView.contentInset = UIEdgeInsets(top: padding, left: 0, bottom: padding, right: 0)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 3
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func saveImage(_ barButton: UIBarButtonItem) {
        UIImageWriteToSavedPhotosAlbum(imageView.image!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    func image(_ image: UIImage, didFinishSavingWithError error: NSError?, contextInfo: UnsafeRawPointer?) {
        if error != nil {
            let alert = UIAlertController(title: "Couldn't Save Wallpaper", message: "Make sure Reddit Walls has access to your photos in your settings.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        }
        else {
            let alert = UIAlertController(title: "Saved Photo!", message: "You can find the wallpaper in your photos app.", preferredStyle: .alert)
            let okay = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(okay)
            present(alert, animated: true, completion: nil)
        }
    }

}

extension SelectedWallpaperViewController: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        let imageViewSize = imageView.frame.size
        let scrollViewSize = scrollView.bounds.size
        
        let verticalPadding = imageViewSize.height < scrollViewSize.height ? (scrollViewSize.height - imageViewSize.height) / 2 : 0
        let horizontalPadding = imageViewSize.width < scrollViewSize.width ? (scrollViewSize.width - imageViewSize.width) / 2 : 0
        
        scrollView.contentInset = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
    }
    
}
