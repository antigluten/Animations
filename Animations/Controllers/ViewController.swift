//
//  ViewController.swift
//  Animations
//
//  Created by Vladimir Gusev on 23.07.2022.
//

import UIKit

class ViewController: UIViewController {
    private var tableView = TableView()
    
    private lazy var menuView = UIView()
    
    private lazy var menuTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Packing List"
        label.font = .systemFont(ofSize: 21)
        label.textAlignment = .center
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var menuButton: UIButton = {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("+", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 27)
        button.clipsToBounds = true
        return button
    }()
    
    private var slider: HorizontalItemSlider?

    private lazy var menuHeightConstraint = NSLayoutConstraint()
    private lazy var menuButtonTrailingConstraint = NSLayoutConstraint()
    private lazy var menuTitleCenterYConstraint = NSLayoutConstraint()
    private lazy var menuTitleCenterXConstraint = NSLayoutConstraint()
    
    private var menuIsOpen = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        setupMenu()
        setupSlider()
        setupTable()
        setupButton()
    }
    
    private func setupSlider() {
        slider = HorizontalItemSlider(in: view) { [unowned self] item in
          self.tableView.addItem(item)
          self.transitionCloseMenu()
        }
        
        slider?.translatesAutoresizingMaskIntoConstraints = false
        
        guard let slider = slider else { return }
        
        menuView.addSubview(slider)
        
        NSLayoutConstraint.activate([
            slider.topAnchor.constraint(equalTo: view.topAnchor, constant: 120),
            slider.leadingAnchor.constraint(equalTo: menuView.leadingAnchor),
            slider.trailingAnchor.constraint(equalTo: menuView.trailingAnchor),
            slider.heightAnchor.constraint(equalToConstant: 80)
        ])
    }
}

// MARK: - private
private extension ViewController {
    func setupMenu() {
        view.addSubview(menuView)
        menuView.translatesAutoresizingMaskIntoConstraints = false
        
        menuView.addSubview(menuTitle)
        menuView.addSubview(menuButton)
        
        menuHeightConstraint = menuView.heightAnchor.constraint(equalToConstant: 80)
        menuButtonTrailingConstraint = menuButton.trailingAnchor.constraint(equalTo: menuView.trailingAnchor, constant: -8)
        
        menuTitleCenterXConstraint = menuTitle.centerXAnchor.constraint(equalTo: menuView.centerXAnchor)
        
        menuTitleCenterYConstraint = menuTitle.centerYAnchor.constraint(equalTo: menuView.centerYAnchor)
        menuTitleCenterYConstraint.priority = UILayoutPriority(750)
        menuTitleCenterYConstraint.identifier = "Menu Title Center Y"
        
        let menuTitleTopConstraint = menuTitle.topAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.topAnchor, constant: 5)
        menuTitleTopConstraint.priority = UILayoutPriority(1000)
        
        NSLayoutConstraint.activate([
            menuView.topAnchor.constraint(equalTo: view.topAnchor),
            menuView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            menuView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            menuHeightConstraint,
            
            menuTitleCenterXConstraint,
            menuTitleTopConstraint,
            menuTitleCenterYConstraint,
            
            menuButton.centerYAnchor.constraint(equalTo: menuTitle.centerYAnchor),
            menuButtonTrailingConstraint
        ])
    }
    
    func setupTable() {
        view.addSubview(tableView)
        
        tableView.handleSelection = showItem
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: menuView.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    func setupButton() {
        menuButton.addTarget(self, action: #selector(toggleMenu), for: .touchUpInside)
    }
    
    @objc func toggleMenu() {
        menuIsOpen.toggle()
        
        menuTitle.text = menuIsOpen ? "Select Item!" : "Packing List"
        view.layoutIfNeeded()
        
        menuTitleCenterXConstraint.constant = menuIsOpen ? -100 : 0
        menuTitleCenterYConstraint.isActive = false
        
        menuTitleCenterYConstraint = NSLayoutConstraint(
            item: menuTitle,
            attribute: .centerY,
            relatedBy: .equal,
            toItem:  menuTitle.superview,
            attribute: .centerY,
            multiplier: menuIsOpen ? 2 / 3 : 1,
            constant: 0)
        
        menuTitleCenterYConstraint.identifier = "Menu Title Center Y"
        menuTitleCenterYConstraint.priority = .defaultHigh
        menuTitleCenterYConstraint.isActive = true
        
        menuHeightConstraint.constant = menuIsOpen ? 200 : 80
        menuButtonTrailingConstraint.constant = menuIsOpen ? -16: -8
        
        UIView.animate(
            withDuration: 1,
            delay: 0,
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 10,
            options: .allowUserInteraction,
            animations: {
                self.menuButton.transform = .init(rotationAngle: self.menuIsOpen ? .pi / 4 : .zero)
                self.view.layoutIfNeeded()
            }
        )
    }
    
    func showItem(_ item: Item) {
        let imageView = UIImageView(item: item)
        imageView.backgroundColor = .init(white: 0, alpha: 0.5)
        imageView.layer.cornerRadius = 5
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        let containerView = UIView(frame: imageView.frame)
        view.addSubview(containerView)
        containerView.addSubview(imageView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        let bottomContraint = containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: containerView.frame.height)
        let widthConstraint = containerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1 / 3, constant: -50)
        
        NSLayoutConstraint.activate([
            bottomContraint,
            widthConstraint,
            containerView.heightAnchor.constraint(equalTo: containerView.widthAnchor),
            containerView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.heightAnchor.constraint(equalTo: containerView.heightAnchor),
            imageView.widthAnchor.constraint(equalTo: containerView.widthAnchor),
            imageView.centerYAnchor.constraint(equalTo: containerView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: containerView.centerXAnchor)
        ])
        
        view.layoutIfNeeded()
        
        UIView.animate(
            withDuration: 0.8,
            delay: 0,
            usingSpringWithDamping: 0.6,
            initialSpringVelocity: 10,
            options: [],
            animations: {
                bottomContraint.constant = imageView.frame.height * -2
                widthConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        )
        
        delay(seconds: 1) {
            UIView.transition(
                with: containerView,
                duration: 1,
                options: .transitionFlipFromBottom
            ) {
                imageView.removeFromSuperview()
            } completion: { _ in
                containerView.removeFromSuperview()
            }
        }
    }
    
    func transitionCloseMenu() {
        delay(seconds: 0.35, execute: toggleMenu)
        
        if let titleBar = slider?.superview {
            UIView.transition(
                with: titleBar,
                duration: 0.5,
                options: [.transitionFlipFromBottom]
            ) {
                self.slider?.isHidden = true
            } completion: { _ in
                self.slider?.isHidden = false
            }

        }
    }
}

private func delay(seconds: TimeInterval, execute: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + seconds, execute: execute)
}
