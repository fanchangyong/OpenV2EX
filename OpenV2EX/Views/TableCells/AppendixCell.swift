//
//  AppendixCell.swift
//  OpenV2EX
//
//  Created by fancy on 5/22/21.
//

import UIKit

class AppendixCell: BaseCell {
    var appendix: Appendix? {
        didSet {
            if let appendix = appendix {
                self.headerLabel.text = "第 \(appendix.index + 1) 条附言 · \(appendix.postAt)"
                self.contentLabel.text = appendix.content
            }
        }
    }

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        self.containerView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.containerView.topAnchor),
            label.leadingAnchor.constraint(equalTo: self.containerView.leadingAnchor),
        ])
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        self.containerView.addSubview(label)
        label.preferredMaxLayoutWidth = containerView.frame.width
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.font = UIFont.systemFont(ofSize: 14)
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: self.headerLabel.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.containerView.trailingAnchor),
            label.bottomAnchor.constraint(lessThanOrEqualTo: self.containerView.bottomAnchor),
        ])
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(named: "AppendixCellBackground")
        self.containerView.addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
