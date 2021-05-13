//
//  TopicCell.swift
//  OpenV2EX
//
//  Created by fancy on 5/11/21.
//

import UIKit
import Kingfisher

class TopicCell: UITableViewCell {
    var topic: Topic? {
        didSet {
            self.setup()
        }
    }
    
    var showNode: Bool = true
    
    private lazy var nodeLabelConstraints = [
        nodeLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
        nodeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
    ]
    
    private lazy var memberLabelConstraintsWithNode = [
        memberLabel.leadingAnchor.constraint(equalTo: self.nodeLabel.trailingAnchor, constant: 6),
        memberLabel.centerYAnchor.constraint(equalTo: self.nodeLabel.centerYAnchor),
    ]
    
    private lazy var memberLabelConstraintsWithoutNode = [
        memberLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
        memberLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
    ]
    
    private lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        self.contentView.addSubview(avatar)
        avatar.layer.cornerRadius = 8
        avatar.clipsToBounds = true
        avatar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            avatar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            avatar.widthAnchor.constraint(equalToConstant: 50),
            avatar.heightAnchor.constraint(equalToConstant: 50),
        ])
        return avatar
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        self.contentView.addSubview(titleLabel)
        titleLabel.preferredMaxLayoutWidth = contentView.frame.width
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.avatar.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: self.avatar.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        return titleLabel
    }()
    
    private lazy var nodeLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 11)
        label.backgroundColor = UIColor(red: 233/250, green: 233/250, blue: 233/250, alpha: 1)
        label.textColor = .darkGray
        label.layer.cornerRadius = 2
        label.clipsToBounds = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var memberLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var postAtLabel: UILabel = {
        let postAtLabel = UILabel()
        self.contentView.addSubview(postAtLabel)
        postAtLabel.font = UIFont.systemFont(ofSize: 11)
        postAtLabel.textColor = .gray
        postAtLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postAtLabel.leadingAnchor.constraint(equalTo: self.memberLabel.trailingAnchor, constant: 0),
            postAtLabel.centerYAnchor.constraint(equalTo: self.memberLabel.centerYAnchor),
        ])
        return postAtLabel
    }()
    
    private lazy var replyCountLabel: UILabel = {
        let replyCountLabel = UILabel()
        self.contentView.addSubview(replyCountLabel)
        replyCountLabel.font = UIFont.systemFont(ofSize: 11)
        replyCountLabel.textColor = .gray
        replyCountLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            replyCountLabel.leadingAnchor.constraint(equalTo: self.postAtLabel.trailingAnchor),
            replyCountLabel.centerYAnchor.constraint(equalTo: self.memberLabel.centerYAnchor),
        ])
        return replyCountLabel
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
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
            postAtLabel.text = " • " + topic.postAt
            replyCountLabel.text = " • " + topic.replyCount + "条"
            avatar.kf.setImage(with: URL(string: topic.avatarURL))
            configureLayouts()
        }
    }
}
