//
//  BaseServices.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

protocol BaseServiceProtocol {
  var urlRequest: URLRequest { get }
}

class BaseService {
  let urlSession: URLSession

  init() {
    urlSession = URLSession(configuration: .default)
  }
  
  func consumeAPI<T: Decodable>(_ decodableType: T.Type, request: BaseServiceProtocol, completion: OnCompletionHandler<T>? = nil) {
    let dataTask = urlSession.dataTask(with: request.urlRequest) { data, response, error in
      print("JSON String: \(String(data: data ?? Data(), encoding: .utf8))")

      guard let uriResponse = response as? HTTPURLResponse else {
        completion?(nil, error)
        return
      }

      let successRange = 200 ... 299
      if successRange.contains(uriResponse.statusCode) {
        guard let responseData = data else { return }
        do {
          let value = try  JSONDecoder().decode(T.self, from: responseData)
          completion?(value, nil)
        } catch let jsonError {
          debugPrint("error \(jsonError)")
        }
      } else {
        completion?(nil, error)
      }
    }
    dataTask.resume()
  }
}
