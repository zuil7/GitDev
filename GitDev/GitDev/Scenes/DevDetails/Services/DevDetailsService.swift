//
//  DevDetailsService.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/14/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

// MARK: - DevDetailsService Protocol
protocol DevDetailsServiceProtocol {
  func getDevDetails(username: String, onHandleCompletion: @escaping ResultClosure<DevDetailsResponse>)
}

final class DevDetailsService: BaseService, DevDetailsServiceProtocol {
  // MARK: - Request Dev Details
  func getDevDetails(username: String, onHandleCompletion: @escaping ResultClosure<DevDetailsResponse>) {
    
    let url: URL! = URL(string: "https://api.github.com/users/\(username)")
    var uriRequest = URLRequest(url: url)
    uriRequest.httpMethod = RestVerbs.GET.rawValue

    consumeAPI(
      DevDetailsResponse.self,
      request: uriRequest,
      completion: { result, err in
        guard err == nil else {
          return onHandleCompletion(nil, false, err?.localizedDescription)
        }
        onHandleCompletion(result, true, err?.localizedDescription)
      }
    )
  }
}
