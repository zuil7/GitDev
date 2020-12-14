//
//  DevProfileViewController.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/14/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Combine
import UIKit

class DevProfileViewController: UIViewController {
  @IBOutlet var avatarImage: UIImageView!
  @IBOutlet var followerLabel: UILabel!
  @IBOutlet var followingLabel: UILabel!
  @IBOutlet var nameLabel: UILabel!
  @IBOutlet var companyLabel: UILabel!
  @IBOutlet var blogLabel: UILabel!

  @IBOutlet var notesTextView: UITextView!
  private var viewModel = DevDetailViewModel(task: DevDetailsService())
  private var imageRequester: AnyCancellable?

  func bindVM(username: String) {
    viewModel.userName = username
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUIElements()
    getDevDetails()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationItem.largeTitleDisplayMode = .never
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    imageRequester?.cancel()
  }
}

private extension DevProfileViewController {
  func setupUIElements() {
    title = " "
    notesTextView.layer.borderWidth = 1
    notesTextView.layer.borderColor = UIColor.black.cgColor
    notesTextView.layer.cornerRadius = 5
  }

  func getDevDetails() {
    viewModel.requestDevInfo(onSuccess: onHandleSuccess(), onError: onHandleError())
  }

  func populateDetails() {
    title = viewModel.devInfo?.name ?? S.noName()
    followerLabel.text = S.followersTitle(viewModel.devInfo?.followers ?? 0)
    followingLabel.text = S.followingTitle(viewModel.devInfo?.following ?? 0)
    nameLabel.text = S.nameTitle(viewModel.devInfo?.name ?? S.noName())
    companyLabel.text = S.companyTitle(viewModel.devInfo?.company ?? S.noCompany())
    blogLabel.text = S.companyTitle(viewModel.devInfo?.blog ?? S.noBlog())
    if let url = URL(string: viewModel.devInfo?.avatarURL ?? .empty) {
      imageRequester = ImageLoader.shared.loadImage(from: url).sink { [weak self] image in
        guard let s = self else { return }
        s.avatarImage.image = image
      }
    }
  }
}

private extension DevProfileViewController {
  @IBAction func saveButtonTapped(_ sender: UIButton) {
  }
}

private extension DevProfileViewController {
  func onHandleSuccess() -> SingleResult<Bool> {
    return { [weak self] status in
      guard let s = self, status else { return }
      DispatchQueue.main.async {
        s.populateDetails()
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
