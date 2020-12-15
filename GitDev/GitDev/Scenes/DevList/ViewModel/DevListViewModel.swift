//
//  ViewModel.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation

protocol DevListViewModelProtocol {
  var lastDevId: Int { get set }
  var sinceId: Int { get set }

  var devList: DevListResponse { get set }
  func requestDevList(
    onSuccess: @escaping SingleResult<Bool>,
    onError: @escaping SingleResult<String>
  )
}

final class DevListViewModel: DevListViewModelProtocol {
  private var service: DevListServiceProtocol
  var devList: DevListResponse = []
  var originalList: DevListResponse = []

  var lastDevId: Int = 0
  var sinceId: Int = 0

  private var queue = OperationQueue()

  init(task: DevListServiceProtocol) {
    service = task
    queue.maxConcurrentOperationCount = 1
  }

  func requestDevList(
    onSuccess: @escaping SingleResult<Bool>,
    onError: @escaping SingleResult<String>
  ) {
    queue.cancelAllOperations()
    queue.qualityOfService = .background

    let user = CDManager.shared.getLastIndexId()
    lastDevId = Int(user?.id ?? 0)

    let block = BlockOperation { [weak self] in
      guard let s = self else { return }
      s.service.getDevList(
        id: s.sinceId, onHandleCompletion: { [weak self] result, status, message in
          guard let s = self else { return }
          if let list = result, status {
            if s.sinceId == 0 {
              CDManager.shared.clearAllDevs()
              s.devList.removeAll()
            }
            s.devList.append(contentsOf: list)
            s.originalList = s.devList
            if let lastDev = list.last {
              let since = Int(lastDev.id)
              print(" COUNT>>> \(list.count). Since:>>> \(since)")
            }
            s.saveToCD()
            onSuccess(status)
          } else {
            onError(message ?? .empty)
          }
        }
      )
    }
    queue.addOperation(block)
  }

  func saveToCD() {
    CDManager.shared.saveContext()
    sinceId = Int(devList[devList.count - 1].id)
  }

  func searchProcess(text: String) {
    if !text.isEmpty {
      devList = originalList.filter({ (devs) -> Bool in
        return (devs.login?.lowercased().contains(text.lowercased()) ?? false)
      })
    } else {
      devList = originalList
    }
  }
  
  func setOriginalList() {
    devList = originalList
  }
  
  func getOfflineUser() {
    devList = CDManager.shared.getUsers()
    originalList = CDManager.shared.getUsers()

  }
}
