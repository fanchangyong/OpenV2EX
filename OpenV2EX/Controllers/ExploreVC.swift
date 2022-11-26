//
//  ExploreViewController.swift
//  OpenV2EX
//
//  Created by fancy on 4/30/21.
//

import UIKit

class ExploreVC: UIViewController {
    let cellID = "\(HotTopicCell.self)"
    var topics: [Topic] = []
    
    let refreshControl = UIRefreshControl()

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        self.view.addSubview(searchBar)
        // Remove search bar's top and bottom borders
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "搜索"
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            searchBar.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            searchBar.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            searchBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
        ])
        return searchBar
    }()
    
    private lazy var dividerBlock: Divider = {
        let divider = Divider()
        self.view.addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            divider.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            divider.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            divider.topAnchor.constraint(equalTo: searchBar.bottomAnchor),
            divider.heightAnchor.constraint(equalToConstant: 8),
        ])
        return divider
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        view.addSubview(label)
        label.text = "今日热议主题"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        label.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: dividerBlock.layoutMarginsGuide.bottomAnchor, constant: 16),
            label.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
        ])
        return label
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.register(HotTopicCell.self, forCellReuseIdentifier: cellID)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: self.headerLabel.bottomAnchor, constant: 10),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        
        // refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        
        return tableView
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .systemBackground
        self.view.addSubview(searchBar)
        self.view.addSubview(dividerBlock)
        self.view.addSubview(headerLabel)
        self.view.addSubview(tableView)
        self.requestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @objc private func refreshData() {
        self.requestData()
    }
    
    private func requestData() {
        API.getHotTopics(completion: {(topics) in
            self.topics = topics
            self.tableView.reloadData()
            self.refreshControl.endRefreshing()
        })
    }
}

extension ExploreVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellID, for: indexPath) as! HotTopicCell
        let topicId = topics[indexPath.row].id
        if (topics[indexPath.row].read != true) {
            let read = UserDefaults.standard.bool(forKey: getTopicReadStateKey(topicId: topicId))
            topics[indexPath.row].read = read
        }
        cell.topic = topics[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = self.topics[indexPath.row]
        let topicDetailVC = TopicDetailVC(topic: topic)
        self.navigationController?.pushViewController(topicDetailVC, animated: true)
        UserDefaults.standard.set(true, forKey: getTopicReadStateKey(topicId: topic.id))
        self.topics[indexPath.row].read = true
        tableView.reloadRows(at: [indexPath], with: .none)
    }
}
