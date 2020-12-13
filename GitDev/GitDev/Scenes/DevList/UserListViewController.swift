//
//  UserListViewController.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import UIKit

class UserListViewController: UIViewController {
  private lazy var searchBar: UISearchController = {
    let searchBar = UISearchController(searchResultsController: nil)
    return searchBar
  }()

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  private var viewModel = DevListViewModel(task: DevListService())

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchBar()
    setupTableView()
    getUsers()
  }
}

private extension UserListViewController {
  func setupTableView() {
    view.addSubview(tableView)
    tableView.frame = view.bounds
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(cell: DevListCell.self)
  }

  func setupSearchBar() {
    title = S.userListTitle()
    navigationItem.searchController = searchBar
  }

  func getUsers() {
    viewModel.requestDevList(
      onSuccess: onHandleSuccess(),
      onError: onHandleError()
    )
  }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.devList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: String(describing: DevListCell.self),
      for: indexPath
    ) as! DevListCell
//    let user = viewModel.users[indexPath.row]
//    cell.userProtocol = self.viewModel
//    cell.configure(user, indexPath, serialQueue)
    let devs = viewModel.devList[indexPath.row]
    cell.configureCell(user: devs)

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

private extension UserListViewController {
  func onHandleSuccess() -> SingleResult<Bool> {
    return { [weak self] _ in
      guard let s = self else { return }
      DispatchQueue.main.async {
        s.tableView.reloadData()
      }
    }
  }

  func onHandleError() -> SingleResult<String> {
    return { [weak self] message in
      guard let s = self else { return }
      s.presentAlertMessage(title: S.errMessage(), message: message)
    }
  }
}
