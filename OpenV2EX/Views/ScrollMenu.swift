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
    
    /*
    var labels2: [String: [String]] = [
        "技术": ["程序员", "Python", "iDEV"],
        "创意": ["分享创造", "设计"],
        "好玩": ["分享发现", "电子游戏"],
        "Apple": ["macOS", "iPhone"],
    ]
 */
    
    /*
    var labels = [
        [
            "name": "技术",
            "subLabels": ["程序员", "Python", "iDEV"],
        ],
        [
            "name": "创意",
            "subLabels": ["分享创造", "设计"],
        ],
    ]
 */
    var dataSource: ScrollMenuDataSource? {
        didSet {
            self.setupTopMenuItems()
        }
    }
    
    var delegate: ScrollMenuDelegate?
    
    // var topLabels: [String] = []
    var bottomLabels: [String] = []
    
    // var labels: [String] = []
    var buttons: [UIButton] = [];
    var subButtons: [UIButton] = [];
    var topSelectedIndex: Int {
        self.delegate?.selectedTopIndex() ?? 0
    }
    var subSelectedIndex: Int? {
        self.delegate?.selectedSubIndex()
    }
    //var bottomSelectedIndex: Int = 0
    // var valueChanged: ((_ index: Int) -> Void)?
    
    private lazy var scrollView: UIScrollView = {
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
            divider.topAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
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
    
    func setupTopMenuItems() {
        let offsetX: CGFloat = 10;
        
        // Remove existing menu items
        if scrollView.subviews.count > 0 {
            for view in scrollView.subviews {
                view.removeFromSuperview()
            }
        }
        buttons = []

        let topLabels = self.dataSource?.topLabels(self) ?? []
        for (index, label) in topLabels.enumerated() {
            let button = UIButton()
            scrollView.addSubview(button)
            button.tag = index
            button.setTitle(label, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 9, bottom: 5, right: 9)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(onSelectTopButton), for: .touchUpInside)

            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: buttons.last?.trailingAnchor ?? scrollView.leadingAnchor, constant: index == 0 ? 0 : offsetX),
                button.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            ])
            
            self.buttons.append(button)
        }
        setTopMenuStyles()
        self.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: buttons.last?.frame.maxX ?? 0, height: buttons.last?.frame.height ?? 0)
        setupSubMenuItems()
    }
    
    func setTopMenuStyles() {
        for button in buttons {
            if (button.tag == self.topSelectedIndex) {
                button.backgroundColor = .darkGray
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.darkGray, for: .normal)
            }
        }
    }
    
    func setupSubMenuItems() {
        let offsetX: CGFloat = 10
        let subLabels = self.dataSource?.subLabels(self, index: self.topSelectedIndex) ?? []
        
        if (subScrollView.subviews.count > 0) {
            for view in subScrollView.subviews {
                view.removeFromSuperview()
            }
        }
        subButtons = []
        
        for (index, label) in subLabels.enumerated() {
            let button = UIButton()
            subScrollView.addSubview(button)
            button.tag = index
            button.setTitle(label, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.addTarget(self, action: #selector(onSelectSubButton(sender:)), for: .touchUpInside)

            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: subButtons.last?.trailingAnchor ?? scrollView.leadingAnchor, constant: index == 0 ? 0 : offsetX),
                button.centerYAnchor.constraint(equalTo: subScrollView.centerYAnchor),
            ])
            subButtons.append(button)
        }
        setSubMenuStyles()
        self.layoutIfNeeded()
        self.subScrollView.contentSize = CGSize(width: subButtons.last?.frame.maxX ?? 0, height: buttons.last?.frame.height ?? 0)
    }
    
    func setSubMenuStyles() {
        for button in subButtons {
            if (button.tag == subSelectedIndex) {
                button.setTitleColor(.systemBlue, for: .normal)
            } else {
                button.setTitleColor(.darkGray, for: .normal)
            }
        }
    }

    @objc func onSelectTopButton(sender: UIButton) {
        delegate?.topValueChanged(sender.tag)
        setTopMenuStyles()
        setupSubMenuItems()
    }
    
    @objc func onSelectSubButton(sender: UIButton) {
        delegate?.subValueChanged(sender.tag)
        setSubMenuStyles()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
