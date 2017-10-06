//
//  Extensions.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 3/31/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import Foundation
import UIKit

extension UIColor
{
    class var hintOfGray: UIColor
    {
        return UIColor(red: 240/255, green: 240/255, blue: 240/255, alpha: 1)
    }
    
    class var redditBlue: UIColor
    {
        return UIColor(red: 38/255, green: 130/255, blue: 211/255, alpha: 1)
    }
}

extension UIView
{
    func centerInParentView()
    {
        guard let parentView = self.superview else { return }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        self.centerXAnchor.constraint(equalTo: parentView.centerXAnchor).isActive = true
        self.centerYAnchor.constraint(equalTo: parentView.centerYAnchor).isActive = true
    }
}
