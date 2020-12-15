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
  @IBOutlet var notesTitleLabel: UILabel!
  @IBOutlet var notesTextView: UITextView!
  @IBOutlet var noteViewContainer: UIView!
  @IBOutlet weak var saveButton: UIButton!
  
  private var viewModel = DevDetailViewModel(task: DevDetailsService())
  private var imageRequester: AnyCancellable?

  func bindVM(username: String) {
    viewModel.userName = username
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupUIElements()
    showSkeleton()
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
  // MARK: - Setup UI Elements
  func setupUIElements() {
    notesTextView.layer.borderWidth = 1
    notesTextView.layer.borderColor = traitCollection.userInterfaceStyle == .dark ? UIColor.white.cgColor : UIColor.black.cgColor
    notesTextView.layer.cornerRadius = 5
    saveButton.isEnabled = false
  }
  
  // MARK: - Show Skeleton View
  func showSkeleton() {
    [avatarImage, followerLabel,
     followingLabel, nameLabel,
     companyLabel, blogLabel,
     notesTitleLabel, noteViewContainer].forEach { $0?.showAnimatedSkeleton() }
  }
  
  // MARK: - Hide Skeleton View
  func hideSkeleton() {
    [avatarImage, followerLabel,
     followingLabel, nameLabel,
     companyLabel, blogLabel,
     notesTitleLabel, noteViewContainer].forEach { $0?.hideSkeleton() }
  }
  
  // MARK: - Request Dev Details
  func getDevDetails() {
    viewModel.requestDevInfo(onSuccess: onHandleSuccess(), onError: onHandleError())
  }
  
  // MARK: - Populate Data after fetch
  func populateDetails() {
    hideSkeleton()
    title = viewModel.devInfo?.name ?? S.noName()
    followerLabel.text = S.followersTitle(viewModel.devInfo?.followers ?? 0)
    followingLabel.text = S.followingTitle(viewModel.devInfo?.following ?? 0)
    nameLabel.text = S.nameTitle(viewModel.devInfo?.name ?? S.noName())
    companyLabel.text = S.companyTitle(viewModel.devInfo?.company ?? S.noCompany())
    blogLabel.text = S.companyTitle(viewModel.devInfo?.blog ?? S.noBlog())
    notesTextView.text = CDManager.shared.getNotesById(id: viewModel.devInfo?.id ?? -1)
    if let url = URL(string: viewModel.devInfo?.avatarURL ?? .empty) {
      imageRequester = ImageLoader.shared.loadImage(from: url).sink { [weak self] image in
        guard let s = self else { return }
        s.avatarImage.image = image
      }
    }
    saveButton.isEnabled = true

  }
}

private extension DevProfileViewController {
  // MARK: - Save Button Action
  @IBAction func saveButtonTapped(_ sender: UIButton) {
    view.endEditing(true)
    guard !notesTextView.text.isEmpty else {
      presentAlertMessage(title: S.errMessage(), message: S.noNotes())
      return
    }
    if let dev = viewModel.devInfo {
      CDManager.shared.saveNotes(dev: dev, notes: notesTextView.text, onSuccess: onSaveSuccess())
    }
  }
}

private extension DevProfileViewController {
  // MARK: - On Success Dev Details Fetch
  func onHandleSuccess() -> SingleResult<Bool> {
    return { [weak self] status in
      guard let s = self, status else { return }
      DispatchQueue.main.async {
        s.populateDetails()
      }
    }
  }

  // MARK: - On Success Save Save Notes
  func onSaveSuccess() -> SingleResult<Bool> {
    return { [weak self] status in
      guard let s = self, status else { return }
      DispatchQueue.main.async {
        s.presentAlertMessage(title: S.successMessage(), message: S.saveTitle())
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
