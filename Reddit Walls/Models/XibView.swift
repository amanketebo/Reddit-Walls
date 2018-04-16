//
//  XibView.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 4/14/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import UIKit

// Thanks Adrien Cognée
// https://medium.com/zenchef-tech-and-product/how-to-visualize-reusable-xibs-in-storyboards-using-ibdesignable-c0488c7f525d

@IBDesignable
class XibView: UIView {
    var contentView: UIView?
    @IBInspectable var nibName: String?

    override func awakeFromNib() {
        xibSetup()
    }

    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        xibSetup()
        contentView?.prepareForInterfaceBuilder()
    }

    private func xibSetup() {
        guard let view = loadViewFromNib() else { return }

        view.frame = bounds
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addSubview(view)
        contentView = view
    }

    func loadViewFromNib() -> UIView? {
        guard let nibName = nibName else { return nil }
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: nibName, bundle: bundle)
        return nib.instantiate(
            withOwner: self,
            options: nil).first as? UIView
    }
}
