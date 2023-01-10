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
        
        searchBar.snp.makeConstraints { make in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(self.view.safeAreaLayoutGuide)
        }
        return searchBar
    }()
    
    private lazy var dividerBlock: Divider = {
        let divider = Divider()
        self.view.addSubview(divider)
        
        divider.snp.makeConstraints { make in
            make.leading.equalTo(self.view)
            make.trailing.equalTo(self.view)
            make.top.equalTo(searchBar.snp.bottom)
            make.height.equalTo(8)
        }
        return divider
    }()
    
    private lazy var headerLabel: UILabel = {
        let label = UILabel()
        view.addSubview(label)
        label.text = "今日热议主题"
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.textColor = .secondaryLabel
        
        label.snp.makeConstraints { make in
            make.top.equalTo(dividerBlock.snp.bottomMargin).offset(16)
            make.leading.equalTo(view.snp.leadingMargin)
            make.trailing.equalTo(view.snp.trailingMargin)
        }
        
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
        
        tableView.snp.makeConstraints { make in
            make.leading.equalTo(self.view.safeAreaLayoutGuide)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide)
            make.top.equalTo(self.headerLabel.snp.bottom).offset(10)
            make.bottom.equalTo(self.view)
        }
        
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
