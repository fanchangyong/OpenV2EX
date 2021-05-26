//
//  ExploreViewController.swift
//  OpenV2EX
//
//  Created by fancy on 4/30/21.
//

import UIKit

class ExploreVC: UIViewController {
    override func viewDidLoad() {
        self.view.backgroundColor = .purple
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
}
