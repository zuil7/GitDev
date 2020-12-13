//
//  DevListRequest.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

struct DevListRequest: BaseServiceProtocol {
//    let params: GetUsersParameters

  var urlRequest: URLRequest {
    let url: URL! = URL(string: "https://api.github.com/users?since=\(0)")
    var request = URLRequest(url: url)

    request.httpMethod = RestVerbs.GET.rawValue

    return request
  }
}
