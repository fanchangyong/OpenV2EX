//
//  AppendixCell.swift
//  OpenV2EX
//
//  Created by fancy on 5/22/21.
//

import UIKit

class AppendixCell: UITableViewCell {
    var appendix: Appendix? {
        didSet {
            if let appendix = appendix {
                self.headerLabel.text = "第 \(appendix.index) 条附言 · \(appendix.postAt)"
                self.contentLabel.text = appendix.content
            }
        }
    }

    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 10),
        ])
        return label
    }()
    
    private lazy var contentLabel: UILabel = {
        let label = UILabel()
        self.contentView.addSubview(label)
        label.preferredMaxLayoutWidth = contentView.frame.width
        label.numberOfLines = 0
        label.adjustsFontSizeToFitWidth = false
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: self.headerLabel.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: 10),
            label.bottomAnchor.constraint(lessThanOrEqualTo: self.contentView.bottomAnchor, constant: -10),
        ])
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.backgroundColor = UIColor(red: 255/255, green: 255/255, blue: 200/255, alpha: 1)
        self.contentView.addSubview(headerLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
