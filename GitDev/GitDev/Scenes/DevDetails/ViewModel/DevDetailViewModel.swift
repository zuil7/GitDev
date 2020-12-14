//
//  DevDetailViewModel.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/14/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

protocol DevDetailsViewModelProtocol {
  var userName: String { get set }
  var devInfo: DevDetailsResponse?  { get set }
  func requestDevInfo(
    onSuccess: @escaping SingleResult<Bool>,
    onError: @escaping SingleResult<String>
  )
}

final class DevDetailViewModel: DevDetailsViewModelProtocol {
  var userName: String = .empty
  var devInfo: DevDetailsResponse?

  private var service: DevDetailsServiceProtocol

  init(task: DevDetailsServiceProtocol) {
    service = task
  }

  func requestDevInfo(onSuccess: @escaping SingleResult<Bool>, onError: @escaping SingleResult<String>) {
    service.getDevDetails(username: userName) { [weak self] result, status, message in
      guard let s = self else { return }
      if status {
        s.devInfo = result
        onSuccess(status)
      } else {
        onError(message ?? .empty)
      }
    }
  }
}
