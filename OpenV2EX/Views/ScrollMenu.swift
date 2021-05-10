//
//  ScrollMenuBar.swift
//  OpenV2EX
//
//  Created by fancy on 5/10/21.
//

import UIKit

class ScrollMenu: UIView {
    
    let labels = ["全部", "技术", "创意", "好玩", "Apple", "酷工作", "交易"]
    var buttons: [UIButton] = [];
    var selectedIndex: Int = 2
    
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
            scrollView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
        return scrollView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupMenuItems()
        
        self.layoutIfNeeded()
        self.scrollView.contentSize = CGSize(width: buttons.last?.frame.maxX ?? 0, height: buttons.last?.frame.height ?? 0)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMenuItems() {
        let offsetX: CGFloat = 10;
        var count = 0
        for label in labels {
            let button = UIButton()
            scrollView.addSubview(button)
            button.tag = count
            button.setTitle(label, for: .normal)
            button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 9, bottom: 5, right: 9)
            button.layer.cornerRadius = 8
            button.addTarget(self, action: #selector(onSelectButton), for: .touchUpInside)

            button.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                button.leadingAnchor.constraint(equalTo: buttons.last?.trailingAnchor ?? scrollView.leadingAnchor, constant: offsetX),
                button.centerYAnchor.constraint(equalTo: scrollView.centerYAnchor),
            ])
            
            self.buttons.append(button)
            count += 1
        }
        setMenuItemsStyle()
    }
    
    func setMenuItemsStyle() {
        for button in buttons {
            if (button.tag == selectedIndex) {
                button.backgroundColor = .darkGray
                button.setTitleColor(.white, for: .normal)
            } else {
                button.backgroundColor = .white
                button.setTitleColor(.darkGray, for: .normal)
            }
        }
    }
    
    @objc func onSelectButton(sender: UIButton) {
        self.selectedIndex = sender.tag
        setMenuItemsStyle()
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
