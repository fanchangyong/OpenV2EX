//
//  CellWithPadding.swift
//  OpenV2EX
//
//  Created by fancy on 5/22/21.
//

import UIKit

class BaseCell: UITableViewCell {
    var padding: CGFloat = 10

    lazy var containerView: UIView = {
        let view = UIView()
        self.contentView.addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: padding),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -padding),
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: padding),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -padding),
        ])
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.addSubview(containerView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
