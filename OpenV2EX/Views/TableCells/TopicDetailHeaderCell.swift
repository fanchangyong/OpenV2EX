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
                
                if let avatarURL = topic.avatarURL, avatarURL != oldValue?.avatarURL {
                    self.avatar.kf.setImage(with: URL(string: avatarURL), options: [.keepCurrentImageWhileLoading])
                } else if topic.avatarURL == nil {
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
        
        avatar.snp.makeConstraints { make in
            make.leading.equalTo(self.containerView)
            make.top.equalTo(self.containerView)
            make.size.equalTo(CGSize(width: 50, height: 50))
        }
        
        return avatar
    }()
    
    private lazy var memberLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 13, weight: .medium)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(self.avatar.snp.top)
            make.leading.equalTo(self.avatar.snp.trailing).offset(10)
        }
        
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
        
        label.snp.makeConstraints { make in
            make.leading.equalTo(self.memberLabel)
            make.top.equalTo(self.memberLabel.snp.bottom).offset(6)
        }
        
        return label
    }()

    private lazy var postAtLabel: UILabel = {
        let postAtLabel = UILabel()
        self.contentView.addSubview(postAtLabel)
        postAtLabel.font = UIFont.systemFont(ofSize: 11)
        postAtLabel.textColor = .gray
        
        postAtLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.nodeLabel.snp.trailing).offset(6)
            make.top.equalTo(self.memberLabel.snp.bottom).offset(6)
        }
        
        return postAtLabel
    }()

    private lazy var titleLabel: UILabel = {
        let titleLabel = UILabel()
        self.contentView.addSubview(titleLabel)
        titleLabel.preferredMaxLayoutWidth = containerView.frame.width
        titleLabel.numberOfLines = 0
        titleLabel.adjustsFontSizeToFitWidth = false
        titleLabel.lineBreakMode = .byTruncatingTail
        titleLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(self.containerView)
            make.trailing.equalTo(self.containerView)
            make.top.equalTo(self.avatar.snp.bottom).offset(10)
            make.bottom.equalTo(self.containerView)
        }
        
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
