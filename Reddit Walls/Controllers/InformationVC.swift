//
//  InformationVC.swift
//  Liberty Motor Freight
//
//  Created by Amanuel Ketebo on 9/14/17.
//  Copyright © 2017 Amanuel Ketebo. All rights reserved.
//

import UIKit

struct Button {
    let title: String
    let color: UIColor

    func makeSystemUIButton() -> UIButton {
        let systemUIButton = UIButton(type: .system)

        systemUIButton.setTitle(self.title, for: .normal)
        systemUIButton.setTitleColor(self.color, for: .normal)
        systemUIButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)

        return systemUIButton
    }
}

class InformationVC: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var buttonStackView: UIStackView!
    @IBOutlet weak var stackViewBorder: UIView!
    @IBOutlet weak var stackViewConstraint: NSLayoutConstraint!

    private var image: UIImage?
    private var message: String!
    private var buttons = [Button]()
    private var autoFadeOut = false

    private var animator = UIViewPropertyAnimator()

    init(message: String, image: UIImage?, buttons: [Button], autoFadeOut: Bool) {
        super.init(nibName: "InformationVC", bundle: nil)
        self.message = message
        self.image = image
        self.buttons = buttons
        self.autoFadeOut = autoFadeOut

        modalTransitionStyle = .crossDissolve
        modalPresentationStyle = .overFullScreen
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    override func viewDidAppear(_ animated: Bool) {
        if autoFadeOut {
            createAnimator()
            animator.startAnimation(afterDelay: 1)
        }
    }

    private func setupViews() {
        messageLabel.text = message
        imageView.image = image

        if buttons.isEmpty {
            stackViewBorder.backgroundColor = .clear
            stackViewConstraint.constant = 0
        } else {
            setupStackView()
        }
    }

    private func setupStackView() {
        buttons.forEach { (button) in
            let systemButton = button.makeSystemUIButton()
            systemButton.addTarget(self, action: #selector(dismissVC), for: .touchUpInside)
        }
    }

    private func createAnimator() {
        animator = UIViewPropertyAnimator(duration: 0.5, curve: .easeInOut, animations: { [weak self] in
            self?.view.alpha = 0
        })
        animator.addCompletion { [weak self] (position) in
            self?.dismiss(animated: false, completion: nil)
        }
    }

    @objc private func dismissVC() {
        dismiss(animated: true, completion: nil)
    }
}
