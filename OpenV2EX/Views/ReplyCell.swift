//
//  ReplyCell.swift
//  OpenV2EX
//
//  Created by fancy on 5/22/21.
//

import UIKit

class ReplyCell: UITableViewCell {
    var reply: Reply? {
        didSet {
            if let reply = reply {
                self.avatar.kf.setImage(with: URL(string: reply.avatarURL))
                self.memberLabel.text = reply.member
                self.postAtLabel.text = reply.postAt
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
            avatar.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -10),
        ])
        return avatar
    }()

    private lazy var memberLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 11, weight: .medium)
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
            postAtLabel.leadingAnchor.constraint(equalTo: self.memberLabel.leadingAnchor, constant: 0),
            postAtLabel.topAnchor.constraint(equalTo: self.memberLabel.bottomAnchor, constant: 6),
        ])
        return postAtLabel
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(avatar)
        self.contentView.addSubview(postAtLabel)
        self.contentView.addSubview(memberLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
