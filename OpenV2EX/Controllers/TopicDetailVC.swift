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
    var replies: [Reply] = []

    let topicHeaderCellId = "\(TopicDetailHeaderCell.self)"
    let topicContentCellId = "\(TopicDetailContentCell.self)"
    let appendixCellId = "\(AppendixCell.self)"
    let replyCellId = "\(ReplyCell.self)"

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
        tableView.contentInset = UIEdgeInsets(top: 10, left: 0, bottom: 10, right: 0)

        tableView.register(TopicDetailHeaderCell.self, forCellReuseIdentifier: topicHeaderCellId)
        tableView.register(TopicDetailContentCell.self, forCellReuseIdentifier: topicContentCellId)
        tableView.register(ReplyCell.self, forCellReuseIdentifier: replyCellId)
        tableView.register(AppendixCell.self, forCellReuseIdentifier: appendixCellId)
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
        API.getTopicDetail(url: "https://v2ex.com/t/691930") { (topicContent, appendices, replies) in
            self.topic.content = topicContent
            self.topic.appendices = appendices
            print("appendices: \(appendices)")
            self.replies = replies
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
    case header = 0, content, appendix, reply
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
        case .appendix:
            return topic.appendices.count
        case .reply:
            return replies.count
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch TopicDetailSections(rawValue: indexPath.section)! {
        case .header, .reply, .appendix:
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
        case .appendix:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.appendixCellId, for: indexPath) as! AppendixCell
            let appendix = self.topic.appendices[indexPath.row]
            if cell.appendix != appendix {
                cell.appendix = appendix
            }
            return cell
        case .reply:
            let cell = tableView.dequeueReusableCell(withIdentifier: self.replyCellId, for: indexPath) as! ReplyCell
            let reply = self.replies[indexPath.row]
            if cell.reply != reply {
                cell.reply = reply
            }
            return cell
        }
    }
}

extension TopicDetailVC: TopicDetailContentCellDelegate {
    func cellHeightChanged(in cell: UITableViewCell, contentHeight: CGFloat) {
        guard tableView.indexPath(for: cell) != nil else {
           return
        }
        
        self.topicContentCellHeight = contentHeight
        if self.topicContentCellHeight != 0 {
            self.tableView.beginUpdates()
            self.tableView.endUpdates()
        }
        
    }
}
