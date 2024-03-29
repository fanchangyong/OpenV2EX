//
//  HotTopicCell.swift
//  OpenV2EX
//
//  Created by fancy on 6/1/21.
//

import UIKit

import UIKit
import Kingfisher

class HotTopicCell: BaseCell {
    var topic: Topic? {
        didSet {
            self.setup()
        }
    }
    
    private lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        self.contentView.addSubview(avatar)
        avatar.layer.cornerRadius = 8
        avatar.clipsToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(greaterThanOrEqualTo: self.containerView.topAnchor),
            avatar.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor),
            avatar.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 40),
            avatar.heightAnchor.constraint(equalToConstant: 40),
        ])
        return avatar
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        self.contentView.addSubview(titleLabel)
        titleLabel.textColor = .label
        titleLabel.preferredMaxLayoutWidth = containerView.frame.width
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byCharWrapping
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(equalTo: self.avatar.centerYAnchor),
            titleLabel.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.avatar.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
        ])
        return titleLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup() {
        if let topic = self.topic, let title = topic.title, let avatarURL = topic.avatarURL {
            let font = UIFont.systemFont(ofSize: 15)
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = font.lineHeight * 0.3
            let attrText = NSAttributedString(string: title, attributes: [.paragraphStyle: paragraphStyle, .font: font])
            titleLabel.attributedText = attrText
            avatar.kf.setImage(with: URL(string: avatarURL), options: [.keepCurrentImageWhileLoading])
            if (topic.read == true) {
                titleLabel.textColor = .secondaryLabel
            } else {
                titleLabel.textColor = .label
            }
        }
    }
}
