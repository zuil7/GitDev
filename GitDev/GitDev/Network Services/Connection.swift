//
//  Connection.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/14/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Reachability
import UIKit

class Connection: NSObject {
  typealias SuccessBlock = ((_ success: Bool) -> Void)
  static let shared = Connection()

  func hasConnection(completion: SuccessBlock) {
    let reachability = try! Reachability()

    if reachability.connection != .unavailable {
      completion(true)
    } else {
      completion(false)
    }
  }
}
