//
//  SettingsTableVC.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 1/25/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController {
    @IBOutlet weak var tableView: UITableView!

    private let userDefaults = UserDefaults.standard
    private let notificationCenter = NotificationCenter.default

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    private func setupViews() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        setApperance()
    }

    @objc private func updateTheme() {
        notificationCenter.post(name: .themeUpdated, object: nil)
    }

    @objc private func setApperance() {
        Theme.shared.styleNavbar(navigationController?.navigationBar)
        Theme.shared.styleBackground(view)
    }

    @IBAction func tappedDone(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsVC: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // swiftlint:disable:next force_cast
        let cell = tableView.dequeueReusableCell(withIdentifier: ThemeCell.identifier, for: indexPath) as! ThemeCell
        // swiftlint:disable:previous force_cast

        cell.delegate = self
        cell.darkSwitch.isOn = Theme.shared.appTheme == .dark ? true : false
        Theme.shared.styleCell(cell)

        return cell
    }
}

extension SettingsVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

extension SettingsVC: ThemeSwitchChanged {
    func themeSwitchChanged(darkSwitch: UISwitch) {
        let theme = darkSwitch.isOn ? AppTheme.dark : AppTheme.light

        userDefaults.set(theme.rawValue, forKey: UserDefaults.themeKey)
        setApperance()
        updateTheme()
        tableView.reloadData()
    }
}
