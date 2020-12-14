//
//  DevListService.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

protocol DevListServiceProtocol {
  func getDevList(id: Int, onHandleCompletion: @escaping ResultClosure<DevListResponse>)
}

final class DevListService: BaseService, DevListServiceProtocol {
  func getDevList(id: Int, onHandleCompletion: @escaping ResultClosure<DevListResponse>) {
    let url: URL! = URL(string: "https://api.github.com/users?since=\(id)")
    var uriRequest = URLRequest(url: url)
    uriRequest.httpMethod = RestVerbs.GET.rawValue
    
    consumeAPI(
      DevListResponse.self,
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
