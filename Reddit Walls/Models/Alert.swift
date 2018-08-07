//
//  Alert.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 8/6/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit

struct Alert {
    static private func showAlert(vc: UIViewController, message: String, image: UIImage, buttons: [Button] = [], autoFadeOut: Bool, completion: (() -> Void)? = nil) {
        let informationVC = InformationVC(message: message, image: image, buttons: buttons, autoFadeOut: autoFadeOut)

        vc.present(informationVC, animated: true, completion: completion)
    }

    static func showWallpaperSaveSuccess(vc: UIViewController, completion: (() -> Void)? = nil) {
        let message = "Wallpaper saved sucessfully!"
        let successImage = #imageLiteral(resourceName: "check")
        
        Alert.showAlert(vc: vc, message: message, image: successImage, autoFadeOut: true, completion: completion)
    }

    static func showPhotosAccessError(vc: UIViewController, completion: (() -> Void)? = nil) {
        let message = "Please change Photo's access settings to be able to save wallpapers"
        let okayButton = Button.okayButton
        let networkErrorImage = #imageLiteral(resourceName: "warning")

        Alert.showAlert(vc: vc, message: message, image: networkErrorImage, buttons: [okayButton], autoFadeOut: false, completion: completion)
    }

    static func showNetworkErrorAlert(vc: UIViewController, completion: (() -> Void)? = nil) {
        let message = "Whoops, looks like something is wrong with the network. Check your connection and try again."
        let okayButton = Button.okayButton
        let networkErrorImage = #imageLiteral(resourceName: "warning")

        Alert.showAlert(vc: vc, message: message, image: networkErrorImage, buttons: [okayButton], autoFadeOut: false, completion: completion)
    }

    static func showRedditServerErrorAlert(vc: UIViewController, completion: (() -> Void)? = nil) {
        let message = "Whoops, looks like something is wrong with the Reddit servers. Please try again later."
        let okayButton = Button.okayButton
        let networkErrorImage = #imageLiteral(resourceName: "warning")

        Alert.showAlert(vc: vc, message: message, image: networkErrorImage, buttons: [okayButton], autoFadeOut: false, completion: completion)
    }
}
