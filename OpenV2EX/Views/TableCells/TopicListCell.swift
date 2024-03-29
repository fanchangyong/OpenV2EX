//
//  TopicListCell.swift
//  OpenV2EX
//
//  Created by fancy on 5/11/21.
//

import UIKit
import Kingfisher

class TopicListCell: BaseCell {
    var topic: Topic? {
        didSet {
            self.setup()
        }
    }
    
    private lazy var nodeLabelConstraints = [
        nodeLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
        nodeLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
        nodeLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
        nodeLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.avatar.bottomAnchor),
    ]
    
    private lazy var memberLabelConstraintsWithNode = [
        memberLabel.leadingAnchor.constraint(equalTo: self.nodeLabel.trailingAnchor, constant: 6),
        memberLabel.centerYAnchor.constraint(equalTo: self.nodeLabel.centerYAnchor),
    ]
    
    private lazy var memberLabelConstraintsWithoutNode = [
        memberLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
        memberLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
        memberLabel.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor),
        memberLabel.bottomAnchor.constraint(greaterThanOrEqualTo: self.avatar.bottomAnchor),
    ]

    private lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        self.contentView.addSubview(avatar)
        avatar.layer.cornerRadius = 8
        avatar.clipsToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            avatar.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 32),
            avatar.heightAnchor.constraint(equalToConstant: 32),
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
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.avatar.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: self.avatar.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
        ])
        return titleLabel
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
        return label
    }()
    
    private lazy var memberLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var lastReplyAtLabel: UILabel = {
        let lastReplyAtLabel = UILabel()
        self.contentView.addSubview(lastReplyAtLabel)
        lastReplyAtLabel.font = UIFont.systemFont(ofSize: 11)
        lastReplyAtLabel.textColor = .secondaryLabel
        lastReplyAtLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            lastReplyAtLabel.leadingAnchor.constraint(equalTo: self.memberLabel.trailingAnchor, constant: 0),
            lastReplyAtLabel.centerYAnchor.constraint(equalTo: self.memberLabel.centerYAnchor),
        ])
        return lastReplyAtLabel
    }()
    
    private lazy var replyCountLabel: UILabel = {
        let replyCountLabel = UILabel()
        self.contentView.addSubview(replyCountLabel)
        replyCountLabel.font = UIFont.systemFont(ofSize: 11)
        replyCountLabel.textColor = .secondaryLabel
        replyCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            replyCountLabel.leadingAnchor.constraint(equalTo: self.lastReplyAtLabel.trailingAnchor),
            replyCountLabel.centerYAnchor.constraint(equalTo: self.memberLabel.centerYAnchor),
        ])
        return replyCountLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configureLayouts() {
        if nodeLabel.superview != nil {
            NSLayoutConstraint.activate(nodeLabelConstraints)
        }

        if nodeLabel.superview == nil {
            NSLayoutConstraint.deactivate(memberLabelConstraintsWithNode)
            NSLayoutConstraint.activate(memberLabelConstraintsWithoutNode)
        } else {
            NSLayoutConstraint.deactivate(memberLabelConstraintsWithoutNode)
            NSLayoutConstraint.activate(memberLabelConstraintsWithNode)
        }
    }

    func setup() {
        if let topic = self.topic {
            titleLabel.text = topic.title
            if let node = topic.node {
                nodeLabel.text = "  " + node + "  "
                self.contentView.addSubview(nodeLabel)
            } else {
                nodeLabel.text = ""
                nodeLabel.removeFromSuperview()
            }
            memberLabel.text = topic.member
            if let lastReplyAt = topic.lastReplyAt {
                lastReplyAtLabel.text = " • " + lastReplyAt
            } else {
                lastReplyAtLabel.text = ""
            }
            if let replyCount = topic.replyCount {
                if (replyCount.count > 0) {
                    replyCountLabel.text = " • " + replyCount + "条回复"
                } else {
                    replyCountLabel.text = " • " + "暂无回复"
                }
            } else {
                replyCountLabel.text = ""
            }
            if let avatarURL = topic.avatarURL {
                avatar.kf.setImage(with: URL(string: avatarURL))
            } else {
                avatar.image = nil
            }
            
            if topic.read == true {
                titleLabel.textColor = .secondaryLabel
            } else {
                titleLabel.textColor = .label
            }
            
            configureLayouts()
        }
    }
}
