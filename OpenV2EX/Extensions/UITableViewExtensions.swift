//
//  UITableViewExtensions.swift
//  OpenV2EX
//
//  Created by Changyong Fan on 2023/1/6.
//

import UIKit

extension UITableView {
    func indexPathExists(indexPath:IndexPath) -> Bool {
          if indexPath.section >= self.numberOfSections {
              return false
          }
          if indexPath.row >= self.numberOfRows(inSection: indexPath.section) {
              return false
          }
          return true
      }
}
