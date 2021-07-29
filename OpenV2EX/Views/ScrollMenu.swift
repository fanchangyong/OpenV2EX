//
//  ScrollMenuBar.swift
//  OpenV2EX
//
//  Created by fancy on 5/10/21.
//

import UIKit

protocol ScrollMenuDataSource {
    func topLabels(_ scrollMenu: ScrollMenu) -> [String];
    func subLabels(_ scrollMenu: ScrollMenu, index: Int) -> [String];
}

protocol ScrollMenuDelegate {
    func topValueChanged(_ value: Int) -> Void;
    func subValueChanged(_ value: Int) -> Void;
    func selectedTopIndex() -> Int;
    func selectedSubIndex() -> Int?;
}

class ScrollMenu: UIView {
    var dataSource: ScrollMenuDataSource? {
        didSet {
            self.setupTopMenuItems()
        }
    }
    
    var delegate: ScrollMenuDelegate?
    
    var topSelectedIndex: Int {
        self.delegate?.selectedTopIndex() ?? 0
    }
    var subSelectedIndex: Int? {
        self.delegate?.selectedSubIndex()
    }
    
    var topButtons: [UIButton] = [];
    var subButtons: [UIButton] = [];

    private lazy var topScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.topAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 45)
        ])
        return scrollView
    }()
    
    private lazy var subScrollView: UIScrollView = {
        let scrollView = UIScrollView()
        self.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: self.divider.bottomAnchor),
            scrollView.heightAnchor.constraint(equalToConstant: 40)
        ])
        return scrollView
    }()
    
    private lazy var divider: Divider = {
        let divider = Divider()
        self.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            divider.topAnchor.constraint(equalTo: topScrollView.bottomAnchor, constant: 0),
            divider.heightAnchor.constraint(equalToConstant: 1),
        ])
        return divider
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.setupTopMenuItems()
        
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenuItems(scrollView: UIScrollView, offsetX: CGFloat, labels: [String]) -> [UIButton] {
        if scrollView.subviews.count > 0 {
            for view in scrollView.subviews {
                view.removeFromSuperview()
            }
        }
        
        var buttons: [UIButton] = []

        for (index, label) in labels.enumerated() {
            let button = UIButton()
            scrollView.addSubview(button)
            button.tag = index
            button.setTitle(label, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)

            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: buttons.last?.trailingAnchor ?? scrollView.leadingAnchor, constant: index == 0 ? 0 : offsetX),
                button.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            ])
            
            buttons.append(button)
        }
        scrollView.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: buttons.last?.frame.maxX ?? 0, height: buttons.last?.frame.height ?? 0)
        return buttons
    }
    
    func setupTopMenuItems() {
        let labels = self.dataSource?.topLabels(self) ?? []
        topButtons = setupMenuItems(scrollView: topScrollView, offsetX: 4, labels: labels)
        
        setTopMenuProperties()
        setupSubMenuItems()
    }
    
    func setTopMenuProperties() {
        for button in topButtons {
            button.layer.cornerRadius = 8
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 9, bottom: 5, right: 9)
            button.addTarget(self, action: #selector(onSelectTopButton), for: .touchUpInside)
            if (button.tag == self.topSelectedIndex) {
                button.backgroundColor = .systemFill
                button.setTitleColor(.label, for: .normal)
            } else {
                button.backgroundColor = .clear
                button.setTitleColor(.label, for: .normal)
            }
        }
    }
    
    func setupSubMenuItems() {

        let subLabels = self.dataSource?.subLabels(self, index: self.topSelectedIndex) ?? []
        
        subButtons = self.setupMenuItems(scrollView: subScrollView, offsetX: 10, labels: subLabels)
        
        setSubmenuProperties()
        self.layoutIfNeeded()
    }
    
    func setSubmenuProperties() {
        for button in subButtons {
            button.addTarget(self, action: #selector(onSelectSubButton(sender:)), for: .touchUpInside)
            if (button.tag == subSelectedIndex) {
                button.setTitleColor(.link, for: .normal)
            } else {
                button.setTitleColor(.secondaryLabel, for: .normal)
            }
        }
    }

    @objc func onSelectTopButton(sender: UIButton) {
        delegate?.topValueChanged(sender.tag)
        setTopMenuProperties()
        setupSubMenuItems()
    }
    
    @objc func onSelectSubButton(sender: UIButton) {
        delegate?.subValueChanged(sender.tag)
        setSubmenuProperties()
    }

}
