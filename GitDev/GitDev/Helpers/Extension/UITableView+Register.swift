//
//  UITableView+Register.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import UIKit

public protocol ReusableProtocol {
  static var identifier: String { get }
}

public extension ReusableProtocol where Self: UIView {
  static var identifier: String {
    return String(describing: self)
  }
}

extension UITableViewCell: ReusableProtocol {}

extension UITableView {
  func register<T: UITableViewCell>(cell: T.Type) {
    register(T.self, forCellReuseIdentifier: T.identifier)
  }
}
