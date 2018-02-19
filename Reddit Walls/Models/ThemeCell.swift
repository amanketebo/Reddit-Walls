//
//  ThemeCell.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 2/4/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import UIKit

protocol ThemeSwitchChanged: NSObjectProtocol {
    func themeSwitchChanged(darkSwitch: UISwitch)
}

class ThemeCell: UITableViewCell {
    @IBOutlet weak var darkSwitch: UISwitch!
    @IBOutlet weak var darkLabel: UILabel!

    weak var delegate: ThemeSwitchChanged?

    static let identifier = "ThemeCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        darkSwitch.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
    }

    @objc private func valueChanged() {
        delegate?.themeSwitchChanged(darkSwitch: darkSwitch)
    }
}
