//
//  HotTopicsVC.swift
//  OpenV2EX
//
//  Created by fancy on 4/30/21.
//

import UIKit

class HomeVC: UIViewController {
    
    var topics: [Topic] = []
    let tabs = ["技术", "创意", "好玩", "Apple", "酷工作", "交易", "城市", "问与答", "最热", "全部"]
    
    let cellID = "Cell"

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        self.view.addSubview(searchBar)
        // Remove search bar's top and bottom borders
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        return searchBar
    }()
    
    private lazy var scrollMenu: ScrollMenu = {
        let scrollMenu = ScrollMenu(labels: tabs) { (index) in
            print("selected: \(index)")
        }
        self.view.addSubview(scrollMenu)
        scrollMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollMenu.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            scrollMenu.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            scrollMenu.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            scrollMenu.heightAnchor.constraint(equalToConstant: 50),
        ])
        return scrollMenu
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.scrollMenu.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Request data
        API.getHotTopics { (topics) in
            self.topics = topics
            self.tableView.reloadData()
        }
    }

}

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath)
        cell.textLabel?.text = topics[indexPath.row % self.topics.count].title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        let topicDetailVC = TopicDetailVC(topic: topic)
        self.navigationController?.pushViewController(topicDetailVC, animated: true)
    }
}
