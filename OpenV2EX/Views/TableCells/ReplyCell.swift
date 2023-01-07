//
//  ReplyCell.swift
//  OpenV2EX
//
//  Created by fancy on 5/22/21.
//

import UIKit

class ReplyCell: BaseCell {
    var reply: Reply? {
        didSet {
            if let reply = reply {
                self.avatar.kf.setImage(with: URL(string: reply.avatarURL), options: [.keepCurrentImageWhileLoading])
                self.memberLabel.text = reply.member
                self.postAtLabel.text = reply.postAt
                if let heartCount = reply.heartCount {
                    self.heartLabel.text =  "❤️\(heartCount)"
                }
                
                self.contentTextView.attributedText = reply.content
            }
        }
    }
    private lazy var avatar: UIImageView = {
        let avatar = UIImageView()
        self.containerView.addSubview(avatar)
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

    private lazy var memberLabel: UILabel = {
        let label = UILabel()
        self.containerView.addSubview(label)
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
        self.containerView.addSubview(postAtLabel)
        postAtLabel.font = UIFont.systemFont(ofSize: 11)
        postAtLabel.textColor = .secondaryLabel
        postAtLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            postAtLabel.leadingAnchor.constraint(equalTo: self.memberLabel.leadingAnchor, constant: 0),
            postAtLabel.topAnchor.constraint(equalTo: self.memberLabel.bottomAnchor, constant: 6),
        ])
        return postAtLabel
    }()
    
    private lazy var heartLabel: UILabel = {
        let label = UILabel()
        self.containerView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 11)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            label.topAnchor.constraint(equalTo: self.avatar.topAnchor),
        ])
        return label
    }()
    
    private lazy var contentTextView: UITextView = {
        let text = TextView()
        self.containerView.addSubview(text)
        text.isScrollEnabled = false
        text.isEditable = false
        text.textContainerInset = UIEdgeInsets.zero
        text.textContainer.lineFragmentPadding = 0
        text.translatesAutoresizingMaskIntoConstraints = false
        text.linkTextAttributes = [.foregroundColor: UIColor.secondaryLabel]
        // text.delegate = self
        NSLayoutConstraint.activate([
            text.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 6),
            text.leadingAnchor.constraint(equalTo: avatar.leadingAnchor),
            text.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            text.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor),
        ])
        return text
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.containerView.addSubview(heartLabel)
        self.containerView.addSubview(avatar)
        self.containerView.addSubview(postAtLabel)
        self.containerView.addSubview(memberLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ReplyCell: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
}
