//
//  TopicDetailHeaderCell.swift
//  OpenV2EX
//
//  Created by fancy on 5/22/21.
//

import UIKit

class TopicDetailHeaderCell: BaseCell {
    var topic: Topic? {
        didSet {
            if let topic = topic {
                self.titleLabel.text = topic.title
                self.memberLabel.text = topic.member
                if let node = topic.node {
                    self.nodeLabel.text = " \(node) "
                } else {
                    self.nodeLabel.text = ""
                }
                if let postAt = topic.postAt {
                    self.postAtLabel.text = "发布于\(postAt)"
                } else {
                    self.postAtLabel.text = ""
                }
                if let avatarURL = topic.avatarURL {
                    self.avatar.kf.setImage(with: URL(string: avatarURL))
                } else {
                    self.avatar.image = nil
                }
            }
        }
    }
    
    private lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        self.contentView.addSubview(avatar)
        avatar.layer.cornerRadius = 8
        avatar.clipsToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            avatar.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 50),
            avatar.heightAnchor.constraint(equalToConstant: 50),
        ])
        return avatar
    }()
    
    private lazy var memberLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.avatar.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.avatar.trailingAnchor, constant: 10),
        ])
        return label
    }()

    private lazy var nodeLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 11)
        label.backgroundColor = .secondarySystemFill
        label.textColor = .secondaryLabel
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: self.memberLabel.leadingAnchor),
            label.topAnchor.constraint(equalTo: self.memberLabel.bottomAnchor, constant: 6),
        ])
        return label
    }()

    private lazy var postAtLabel: UILabel = {
        let postAtLabel = UILabel()
        self.contentView.addSubview(postAtLabel)
        postAtLabel.font = UIFont.systemFont(ofSize: 11)
        postAtLabel.textColor = .gray
        postAtLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postAtLabel.leadingAnchor.constraint(equalTo: self.nodeLabel.trailingAnchor, constant: 6),
            postAtLabel.topAnchor.constraint(equalTo: self.memberLabel.bottomAnchor, constant: 6),
            // postAtLabel.bottomAnchor.constraint(equalTo: self.avatar.bottomAnchor),
        ])
        return postAtLabel
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        self.contentView.addSubview(titleLabel)
        titleLabel.preferredMaxLayoutWidth = containerView.frame.width
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.avatar.bottomAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
        ])
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.separatorInset = UIEdgeInsets(top: 0, left: UIScreen.main.bounds.width, bottom: 0, right: 0)
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(memberLabel)
        self.contentView.addSubview(postAtLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
