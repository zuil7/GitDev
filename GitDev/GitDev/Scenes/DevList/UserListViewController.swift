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
    searchBar.searchResultsUpdater = self
    searchBar.obscuresBackgroundDuringPresentation = false
    return searchBar
  }()

  private lazy var tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()

  private var viewModel = DevListViewModel(task: DevListService())
  private var queue = OperationQueue()
  private var isSearching: Bool = false
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
    searchBar.delegate = self
    navigationController?.navigationBar.prefersLargeTitles = true
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
    let devs = viewModel.devList[indexPath.row]
    cell.configureCell(user: devs, idx: indexPath.row)

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//      if let reachability = try? Reachability(), reachability.connection == .unavailable {
//          return
//      }

    let lastItem = viewModel.devList.count - 1
    if indexPath.row == lastItem {
      let spinner = UIActivityIndicatorView(style: .medium)
      spinner.startAnimating()
      spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 44.0)
      tableView.tableFooterView = spinner

      if !isSearching {
        getUsers()
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) {
          tableView.tableFooterView = nil
        }
      } else {
        tableView.tableFooterView = nil
      }
    }
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let vc = DevProfileViewController(nibName: "DevProfileViewController", bundle: nil) 
    vc.bindVM(username: viewModel.devList[indexPath.row].login ?? .empty)
    navigationController?.pushViewController(vc, animated: true)
  }
}

private extension UserListViewController {
  func onHandleSuccess() -> SingleResult<Bool> {
    return { [weak self] status in
      guard let s = self, status else { return }
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

extension UserListViewController: UISearchControllerDelegate, UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    if let text = searchController.searchBar.text, !text.isEmpty {
      isSearching = true
      viewModel.searchProcess(text: text)
    } else {
      isSearching = false
      viewModel.setOriginalList()
    }
    tableView.reloadData()
  }
}
