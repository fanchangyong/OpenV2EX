//
//  TopicDetailVC.swift
//  OpenV2EX
//
//  Created by fancy on 5/2/21.
//

import UIKit
import WebKit

class TopicDetailVC: UIViewController {
    // let topicURL: String
    var topic: Topic

    let topicHeaderCellId = "\(TopicDetailHeaderCell.self)"
    let topicContentCellId = "\(TopicDetailContentCell.self)"

    var topicContentCellHeight: CGFloat?

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        self.view.addSubview(tableView)

        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.leadingAnchor, constant: 0),
            tableView.trailingAnchor.constraint(equalTo: self.view.layoutMarginsGuide.trailingAnchor, constant: 0),
        ])
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UITableViewHeaderFooterView()
        tableView.separatorInset = UIEdgeInsets.zero

        tableView.register(TopicDetailHeaderCell.self, forCellReuseIdentifier: topicHeaderCellId)
        tableView.register(TopicDetailContentCell.self, forCellReuseIdentifier: topicContentCellId)
        return tableView
    }()
    

    init(topic: Topic) {
        self.topic = topic
        super.init(nibName: nil, bundle: nil)
        self.requestData()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hidesBottomBarWhenPushed = true
        self.view.backgroundColor = .white
        self.view.addSubview(tableView)
    }
    
    func requestData() {
        API.getTopicDetail(url: topic.url) { (topicContent) in
            self.topic.content = topicContent
            // self.topicDetail = TopicDetail(topic: self.topic, content: topicContent)
            self.tableView.reloadData()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

enum TopicDetailSections: Int, CaseIterable {
    case header = 0, content
}

extension TopicDetailVC: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return TopicDetailSections.allCases.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionEnum = TopicDetailSections(rawValue: section)
        switch sectionEnum {
        case .header:
            return 1
        case .content:
            return 1
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch TopicDetailSections(rawValue: indexPath.section)! {
        case .header:
            return UITableView.automaticDimension
        case .content:
            return self.topicContentCellHeight ?? 44
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch TopicDetailSections(rawValue: indexPath.section)! {
        case .header:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.topicHeaderCellId, for: indexPath) as! TopicDetailHeaderCell
            if cell.topic != self.topic {
                cell.topic = self.topic
            }
            //
            return cell
        case .content:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.topicContentCellId, for: indexPath) as! TopicDetailContentCell
            if cell.topic != self.topic {
                cell.topic = self.topic
            }
            cell.delegate = self
            return cell
        }
    }
}

extension TopicDetailVC: TopicDetailContentCellDelegate {
    func cellHeightChanged(in cell: UITableViewCell, contentHeight: CGFloat) {
        guard let indexPath = tableView.indexPath(for: cell) else {
           return
        }
        
        self.topicContentCellHeight = contentHeight
        if self.topicContentCellHeight != 0 {
            self.tableView.reloadRows(at: [indexPath], with: .none)
        }
        
    }
}
