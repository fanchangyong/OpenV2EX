//
//  HotTopicsVC.swift
//  OpenV2EX
//
//  Created by fancy on 4/30/21.
//

import UIKit
import SafariServices

let keySelectedTabIndex = "keySelectedTabIndex"

class HomeVC: UIViewController {
    
    var topics: [Topic] = []
    var tabs: [Tab] = []
    var secondaryTabs: [Tab] = []
    
    var selectedTabIndex = UserDefaults.standard.integer(forKey: keySelectedTabIndex)
    var selectedSecTabIndex: Int?
    
    var curPage = 1
    
    let topicListCellID = "\(TopicListCell.self)"

    private lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        self.view.addSubview(searchBar)
        // Remove search bar's top and bottom borders
        searchBar.backgroundImage = UIImage()
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        searchBar.placeholder = "搜索"
        searchBar.delegate = self
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
    
    let refreshControl = UIRefreshControl()
    
    private lazy var loadMoreSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView()
        spinner.hidesWhenStopped = true
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: self.tableView.bounds.width, height: 44.0)
        return spinner
    }()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        self.view.addSubview(tableView)
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
            tableView.topAnchor.constraint(equalTo: self.dividerBlock.bottomAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
        ])
        tableView.dataSource = self
        tableView.delegate = self
        
        tableView.tableFooterView = UITableViewHeaderFooterView()

        tableView.register(TopicListCell.self, forCellReuseIdentifier: topicListCellID)

        // refresh control
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        return tableView
    }()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor = .systemBackground

        // Request data
        requestData()
    }
    
    func requestData(needClearData: Bool = true) {
        if needClearData {
            self.topics = []
            self.tableView.reloadData()
        }

        self.refreshControl.beginRefreshing()

        if let selectedSecTabIndex = self.selectedSecTabIndex {
            let secTab = self.secondaryTabs[selectedSecTabIndex]
            API.getTopicsByNode(secTab.url, page: curPage) { topics in
                self.topics += topics
                self.refreshControl.endRefreshing()
                self.loadMoreSpinner.stopAnimating()
                self.tableView.reloadData()
            }
        } else {
            var url: String?
            if self.tabs.indices.contains(selectedTabIndex) {
                url = self.tabs[selectedTabIndex].url
            }
            
            API.getTopicsByTab(url ?? "") { (topics, tabs, secTabs) in
                self.tabs = tabs
                self.secondaryTabs = secTabs
                self.scrollMenu.setupTopMenuItems()
                self.topics = topics
                self.refreshControl.endRefreshing()
                self.tableView.reloadData()
            }
        }
    }

}

// MARK: UITableView DataSource/Delegate

extension HomeVC: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return topics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.topicListCellID, for: indexPath) as! TopicListCell
        cell.topic = topics[indexPath.row]
        if indexPath.row == self.topics.count - 1 && self.selectedSecTabIndex != nil {
            print("last row reached")
            // add spinner
            self.tableView.tableFooterView = self.loadMoreSpinner
            self.loadMoreSpinner.startAnimating()
            self.curPage = self.curPage + 1
            self.requestData(needClearData: false)
        }
        return cell
    }
    
    /*
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let spinner = UIActivityIndicatorView()
        spinner.frame = CGRect(x: 0.0, y: 0.0, width: self.tableView.bounds.width, height: 44.0)
        if isLoadingMore {
            spinner.startAnimating()
        }
        return spinner
    }
    */
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let topic = topics[indexPath.row]
        let topicDetailVC = TopicDetailVC(topic: topic)
        self.navigationController?.pushViewController(topicDetailVC, animated: true)
    }

    @objc private func refreshData() {
        self.requestData(needClearData: false)
    }
}

// MARK: Scroll Menu data source
extension HomeVC: ScrollMenuDataSource, ScrollMenuDelegate {
    func topLabels(_ scrollMenu: ScrollMenu) -> [String] {
        let labels = self.tabs.map { $0.name }
        return labels
    }
    
    func subLabels(_ scrollMenu: ScrollMenu, index: Int) -> [String] {
        let subLabels = secondaryTabs.map { $0.name }
        return subLabels
    }
    
    func topValueChanged(_ index: Int) {
        self.selectedTabIndex = index
        UserDefaults.standard.set(index, forKey: keySelectedTabIndex)
        self.selectedSecTabIndex = nil
        self.secondaryTabs = []
        self.requestData()
    }
    
    func subValueChanged(_ index: Int) {
        self.selectedSecTabIndex = index
        self.curPage = 1
        self.requestData()
    }
    
    func selectedTopIndex() -> Int {
        return self.selectedTabIndex
    }
    
    func selectedSubIndex() -> Int? {
        return self.selectedSecTabIndex
    }
}

// MARK: UISearchBar delegate
extension HomeVC: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            print("text: \(text)")
            let url = "https://www.google.com/search?q=site:v2ex.com/t%20\(text)"
            let vc = SFSafariViewController(url: URL(string: url)!)
            self.present(vc, animated: true)
        }
    }
    
}
