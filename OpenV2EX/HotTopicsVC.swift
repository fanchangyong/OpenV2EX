//
//  HotTopicsVC.swift
//  OpenV2EX
//
//  Created by fancy on 4/30/21.
//

import UIKit

class HotTopicsVC: UITableViewController {
    let articles = [
        "Article 1",
        "Article 2",
        "Article 3"
    ]
    
    let cellID = "Cell"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // self.view.backgroundColor = .yellow
        // self.setupTableView()
        self.tableView.tableFooterView = UITableViewHeaderFooterView()
        // self.tableView.rowHeight = 100
        self.tableView.backgroundColor = .lightGray
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: self.cellID)
    }

    /*
    func setupTableView() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        // constraints
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
        ])

        // popular data
        // tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.rowHeight = 100
    }
 */

}

extension HotTopicsVC {
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("table view 1: \(self.articles.count), section: \(section)")
        return articles.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        print("table view 2")
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        /*
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: self.cellID)
            cell.textLabel?.textAlignment = .right
        }
 */
        cell.backgroundColor = .yellow
        cell.textLabel?.text = articles[indexPath.row]
        return cell
        /*
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = articles[indexPath.row]
        return cell
 */
    }
}
