//
//  UserListViewController.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Combine
import Connectivity
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

  private lazy var toastView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private lazy var toastLabel: UILabel = {
    let label = UILabel()
    label.textColor = .white
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private var viewModel = DevListViewModel(task: DevListService())
  private var queue = OperationQueue()
  private var isSearching: Bool = false

  private let connectivity = Connectivity()
  private var cancellable: AnyCancellable?

  private var isComingFromOffline: Bool = false
  private var isOffline: Bool = false

  override func viewDidLoad() {
    super.viewDidLoad()
    setupSearchBar()
    setupTableView()
    setupToastView()
    setupConnectiviy()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setupConnectivityNotifier()
    tableView.reloadData()
  }
}

private extension UserListViewController {
  // MARK: - Setup Tableview
  func setupTableView() {
    view.addSubview(tableView)
    tableView.frame = view.bounds
    tableView.delegate = self
    tableView.dataSource = self
    tableView.register(cell: DevListCell.self)
  }
  
  // MARK: - Check Connectivity and load user according if online or offline
  func setupConnectiviy() {
    if isOffline {
      showOfflineToastBar()
      getOfflineUsers()
    } else {
      getUsers()
    }
  }
  
  // MARK: - Setup Connectivity Observer
  func setupConnectivityNotifier() {
    let publisher = Connectivity.Publisher()
    cancellable = publisher.receive(on: DispatchQueue.main)
      .eraseToAnyPublisher()
      .sink(receiveCompletion: { _ in
      }, receiveValue: { [weak self] connectivity in
        guard let s = self else {
          return
        }
        s.updateConnectionStatus(connectivity.status)
      })
  }
  
  // MARK: - Check update connectivity and display online or offline
  func updateConnectionStatus(_ status: Connectivity.Status) {
    switch status {
    case .connectedViaWiFi, .connectedViaCellular, .connected:
      isOffline = false
      if isComingFromOffline {
        isComingFromOffline = false
        showOnlineToastBar()
      }
    case .connectedViaWiFiWithoutInternet, .connectedViaCellularWithoutInternet, .notConnected:
      isOffline = true
      isComingFromOffline = true
      showOfflineToastBar()
    case .determining:
      break
    }
  }

  // MARK: - Setup Toast View for Online and Offline
  func setupToastView() {
    view.addSubview(toastView)
    NSLayoutConstraint.activate([
      toastView.topAnchor.constraint(equalTo: view.topAnchor),
      toastView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
      toastView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
      toastView.heightAnchor.constraint(equalToConstant: 70)
    ])

    toastView.addSubview(toastLabel)

    NSLayoutConstraint.activate([
      toastLabel.centerYAnchor.constraint(equalTo: toastView.centerYAnchor),
      toastLabel.centerXAnchor.constraint(equalTo: toastView.centerXAnchor)
    ])

    toastView.isHidden = true
  }
  
  // MARK: - Setup Search Bar
  func setupSearchBar() {
    title = S.userListTitle()
    searchBar.delegate = self
    navigationController?.navigationBar.prefersLargeTitles = true
    navigationItem.searchController = searchBar
  }
  
  // MARK: - Get Devs
  func getUsers() {
    viewModel.requestDevList(
      onSuccess: onHandleSuccess(),
      onError: onHandleError()
    )
  }
  
  // MARK: - Get Devs in Core Data during offline mode
  func getOfflineUsers() {
    viewModel.getOfflineUser()
    tableView.reloadData()
  }
  
  // MARK: - Show offline toast
  func showOfflineToastBar() {
    toastView.backgroundColor = .red
    toastLabel.text = S.offlineTitle()

    toastView.isHidden = false
  }
  
  // MARK: - Show online toast view
   func showOnlineToastBar() {
    toastView.backgroundColor = .green
    toastLabel.text = S.onlineTitle()

    toastView.isHidden = false

    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(5)) {
      [unowned self] in
      self.toastView.isHidden = true
    }
  }
}

extension UserListViewController: UITableViewDataSource, UITableViewDelegate {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.devList.count == 0 ? 10 : viewModel.devList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(
      withIdentifier: String(describing: DevListCell.self),
      for: indexPath
    ) as! DevListCell
    if viewModel.devList.count != 0 {
      cell.hideSkeletalView()
      let devs = viewModel.devList[indexPath.row]
      cell.configureCell(user: devs, idx: indexPath.row)
    } else {
      cell.showAnimatedGradientSkeleton()
    }

    return cell
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }

  func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    cell.selectionStyle = .none

    let lastItem = viewModel.devList.count - 1
    if indexPath.row == lastItem {
      let spinner = UIActivityIndicatorView(style: .medium)
      spinner.startAnimating()
      spinner.frame = CGRect(x: 0.0, y: 0.0, width: tableView.bounds.width, height: 44.0)
      tableView.tableFooterView = spinner

      if !isSearching && !isOffline {
        toastView.isHidden = true
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
  // MARK: - On Success Getting Dev list
  func onHandleSuccess() -> SingleResult<Bool> {
    return { [weak self] status in
      guard let s = self, status else { return }
      DispatchQueue.main.async {
        s.tableView.reloadData()
      }
    }
  }
  
  // MARK: - Display Error encountered after fetch
  func onHandleError() -> SingleResult<String> {
    return { [weak self] message in
      guard let s = self else { return }
      s.presentAlertMessage(title: S.errMessage(), message: message)
    }
  }
}

extension UserListViewController: UISearchControllerDelegate, UISearchResultsUpdating {
  // MARK: - Update Search Result
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
