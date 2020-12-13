//
//  ViewModel.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

protocol DevListViewModelProtocol {
  var devList: DevListResponse { get set }

  func requestDevList(
    onSuccess: @escaping SingleResult<Bool>,
    onError: @escaping SingleResult<String>
  )}

final class DevListViewModel: DevListViewModelProtocol {
  private var service: DevListServiceProtocol
  var devList: DevListResponse = []

  init(task: DevListServiceProtocol) {
    service = task
  }

  func requestDevList(
    onSuccess: @escaping SingleResult<Bool>,
    onError: @escaping SingleResult<String>
  ) {
    service.getDevList(
      onHandleCompletion: { [weak self] result, status, message in
        guard let s = self else { return }
        if let list = result, status {
          s.devList = list
          onSuccess(status)
        } else {
          onError(message ?? .empty)
        }
      }
    )
  }
}
