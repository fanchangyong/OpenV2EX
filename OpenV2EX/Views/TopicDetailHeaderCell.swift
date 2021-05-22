//
//  TopicDetailHeaderCell.swift
//  OpenV2EX
//
//  Created by fancy on 5/22/21.
//

import UIKit

class TopicDetailHeaderCell: UITableViewCell {
    var topicDetail: TopicDetail? {
        didSet {
            if let topicDetail = topicDetail {
                self.titleLabel.text = topicDetail.title
                self.memberLabel.text = topicDetail.member
                self.postAtLabel.text = "发布于\(topicDetail.postAt)"
                self.avatar.kf.setImage(with: URL(string: topicDetail.avatarURL))
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
            avatar.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            avatar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
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
    
    private lazy var postAtLabel: UILabel = {
        let postAtLabel = UILabel()
        self.contentView.addSubview(postAtLabel)
        postAtLabel.font = UIFont.systemFont(ofSize: 11)
        postAtLabel.textColor = .gray
        postAtLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postAtLabel.leadingAnchor.constraint(equalTo: self.memberLabel.leadingAnchor),
            postAtLabel.topAnchor.constraint(equalTo: self.memberLabel.bottomAnchor, constant: 6),
            // postAtLabel.bottomAnchor.constraint(equalTo: self.avatar.bottomAnchor),
        ])
        return postAtLabel
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        self.contentView.addSubview(titleLabel)
        titleLabel.preferredMaxLayoutWidth = contentView.frame.width
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: 24, weight: .medium)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.avatar.bottomAnchor, constant: 10),
            titleLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            titleLabel.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        return titleLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(memberLabel)
        self.contentView.addSubview(postAtLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
