//
//  SaveToCameraRollActivity.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 12/28/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit

class CustomSaveToCameraRollActivity: UIActivity {
    override var activityType: UIActivityType? {
        return .customSaveToCameraRoll
    }
    
    override var activityTitle: String? {
        return "Save Wallpaper"
    }
    
    override var activityImage: UIImage? {
        return #imageLiteral(resourceName: "savewallpaper")
    }
    
    override class var activityCategory: UIActivityCategory {
        return .action
    }
    
    override func canPerform(withActivityItems activityItems: [Any]) -> Bool {
        var canPerform = true
        
        for activityItem in activityItems {
            if let _ = activityItem as? UIImage {
                // Since this is empty, try to refactor this
            } else {
                canPerform = false
            }
        }
        
        return canPerform
    }
}
