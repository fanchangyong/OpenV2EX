//
//  ProfileVC.swift
//  OpenV2EX
//
//  Created by Changyong Fan on 2023/1/1.
//

import UIKit

class ProfileVC: UIViewController {
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        button.setTitle("Login", for: .normal)
        button.addTarget(self, action: #selector(onTapLogin), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
        ])
        return button
    }()
    
    @objc func onTapLogin() {
        print("on tap login")
        let webviewVC = WebViewVC()
        self.present(webviewVC, animated: true)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(loginButton)
    }

}
