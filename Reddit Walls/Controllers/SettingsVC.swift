//
//  SettingsTableVC.swift
//  Reddit Walls
//
//  Created by Amanuel Ketebo on 1/25/18.
//  Copyright © 2018 Amanuel Ketebo. All rights reserved.
//

import UIKit

enum AppTheme: Int {
    case light
    case dark
}

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
        let savedTheme = userDefaults.integer(forKey: UserDefaults.themeKey)
        guard let appTheme = AppTheme(rawValue: savedTheme) else { return }

        switch  appTheme{
        case .light:
            navigationController?.navigationBar.barTintColor = .redditBlue
            view.backgroundColor = .white
        case .dark:
            navigationController?.navigationBar.barTintColor = .lightBlack
            view.backgroundColor = .darkBlack
        }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: ThemeCell.identifier, for: indexPath) as! ThemeCell
        let savedTheme = userDefaults.integer(forKey: UserDefaults.themeKey)

        cell.delegate = self

        if let theme = AppTheme(rawValue: savedTheme) {
            cell.darkSwitch.isOn = theme == .dark ? true : false

            switch theme {
            case .light:
                cell.contentView.backgroundColor = .white
                cell.darkLabel.textColor = .black
                cell.darkSwitch.onTintColor = nil
            case .dark:
                cell.contentView.backgroundColor = .darkBlack
                cell.darkLabel.textColor = .white
                cell.darkSwitch.onTintColor = .redditBlue
            }
        }

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
