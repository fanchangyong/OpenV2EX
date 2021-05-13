//
//  HotTopicsVC.swift
//  OpenV2EX
//
//  Created by fancy on 4/30/21.
//

import UIKit

class HomeVC: UIViewController {
    
    var topics: [Topic] = []
    
    var selectedTabIndex = 0
    var selectedNodeIndex: Int?

    let cellID = "Cell"

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        self.view.addSubview(searchBar)
        // Remove search bar's top and bottom borders
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "搜索"
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        return searchBar
    }()
    
    private lazy var scrollMenu: ScrollMenu = {
        let scrollMenu = ScrollMenu()
        scrollMenu.dataSource = self
        scrollMenu.delegate = self
        self.view.addSubview(scrollMenu)
        scrollMenu.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollMenu.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 0),
            scrollMenu.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: -0),
            scrollMenu.topAnchor.constraint(equalTo: self.searchBar.bottomAnchor),
            scrollMenu.heightAnchor.constraint(equalToConstant: 86),
        ])
        return scrollMenu
    }()
    
    private lazy var dividerBlock: Divider = {
        let divider = Divider()
        self.view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            divider.topAnchor.constraint(equalTo: scrollMenu.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 8),
        ])
        return divider
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.rowHeight = 80
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: self.dividerBlock.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.register(TopicCell.self, forCellReuseIdentifier: cellID)
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
        requestData()
    }
    
    func requestData() {
        self.topics = []
        self.tableView.reloadData()
        
        if let selectedNodeIndex = self.selectedNodeIndex {
            let subLabels = labels[self.selectedTabIndex]["subLabels"] as! [String]
            let nodeLabel = subLabels[selectedNodeIndex]
            let node = labelToNodes[nodeLabel] ?? ""
            API.getTopicsByNode(node) { topics in
                self.topics = topics
                self.tableView.reloadData()
            }
        } else {
            let label = labels[selectedTabIndex]["name"] as! String
            let tab = labelToTabs[label] ?? ""
            API.getTopicsByTab(tab) { topics in
                self.topics = topics
                self.tableView.reloadData()
            }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! TopicCell
        cell.topic = topics[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        let topicDetailVC = TopicDetailVC(topic: topic)
        self.navigationController?.pushViewController(topicDetailVC, animated: true)
    }
}

let labelToTabs = [
    "技术": "tech",
    "创意": "creative",
    "好玩": "play",
    "Apple": "apple",
]

let labelToNodes = [
    "程序员": "programmer",
    "Python": "python",
]

let labels = [
    [
        "name": "技术",
        "subLabels": ["程序员", "Python", "iDEV", "Android", "Linux", "node.js", "云计算", "宽带症候群"],
    ],
    [
        "name": "创意",
        "subLabels": ["分享创造", "设计", "奇思妙想"],
    ],
    [
        "name": "好玩",
        "subLabels": ["分享发现", "电子游戏", "电影"]
    ],
    [
        "name": "Apple",
        "subLabels": ["macOS", "iPhone", "iPad", "MBP", " WATCH", "Apple"],
    ],
]

// MARK Scroll Menu data source
extension HomeVC: ScrollMenuDataSource, ScrollMenuDelegate {
    func topLabels(_ scrollMenu: ScrollMenu) -> [String] {
        var topLabels: [String] = []
        for label in labels {
            topLabels.append(label["name"] as! String)
        }
        return topLabels
    }
    
    func subLabels(_ scrollMenu: ScrollMenu, index: Int) -> [String] {
        return labels[index]["subLabels"] as! [String]
    }
    
    func topValueChanged(_ index: Int) {
        self.selectedTabIndex = index
        self.selectedNodeIndex = nil
        self.requestData()
    }
    
    func subValueChanged(_ index: Int) {
        self.selectedNodeIndex = index
        self.requestData()
    }
}
