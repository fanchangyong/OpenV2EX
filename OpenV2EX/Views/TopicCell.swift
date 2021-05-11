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
            print("### setting topic")
            self.setup()
        }
    }
    
    private lazy var avatar: UIImageView = {
        let view = UIImageView()
        self.contentView.addSubview(view)
        view.layer.cornerRadius = 8
        view.clipsToBounds = true

        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        label.preferredMaxLayoutWidth = contentView.frame.width
        label.numberOfLines = 2
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.systemFont(ofSize: 15, weight: .medium)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
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
        let label = UILabel()
        self.contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureLayouts() {
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            avatar.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
            avatar.widthAnchor.constraint(equalToConstant: 50),
            avatar.heightAnchor.constraint(equalToConstant: 50),
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: self.avatar.topAnchor, constant: 0),
            titleLabel.leadingAnchor.constraint(equalTo: self.avatar.trailingAnchor, constant: 8),
            titleLabel.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor),
        ])
        
        NSLayoutConstraint.activate([
            nodeLabel.leadingAnchor.constraint(equalTo: self.titleLabel.leadingAnchor),
            // nodeLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 2),
            nodeLabel.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10),
            nodeLabel.heightAnchor.constraint(equalToConstant: 18),
        ])
        
        NSLayoutConstraint.activate([
            memberLabel.leadingAnchor.constraint(equalTo: self.nodeLabel.trailingAnchor, constant: 10),
            memberLabel.centerYAnchor.constraint(equalTo: self.nodeLabel.centerYAnchor),
        ])
        
        NSLayoutConstraint.activate([
            postAtLabel.leadingAnchor.constraint(equalTo: self.memberLabel.trailingAnchor, constant: 10),
            postAtLabel.centerYAnchor.constraint(equalTo: self.memberLabel.centerYAnchor),
        ])
        
    }

    func setup() {
        if let topic = self.topic {
            titleLabel.text = topic.title
            nodeLabel.text = "  " + topic.node + "  "
            memberLabel.text = " •   " + topic.member
            postAtLabel.text = " •   " + topic.postAt
            avatar.kf.setImage(with: URL(string: topic.avatarURL))
            configureLayouts()
        }
    }
}
