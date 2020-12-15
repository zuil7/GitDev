//
//  DevListCell.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Combine
import SkeletonView
import UIKit

class DevListCell: UITableViewCell {
  lazy var avatarUIImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.backgroundColor = .lightGray
    image.isSkeletonable = true
    contentView.addSubview(image)
    return image
  }()

  lazy var usernameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = .boldSystemFont(ofSize: 16)
    label.text = "  "
    label.isSkeletonable = true
    contentView.addSubview(label)
    return label
  }()

  lazy var uriLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = .boldSystemFont(ofSize: 16)
    label.text = "  "
    label.isSkeletonable = true
    contentView.addSubview(label)
    return label
  }()

  lazy var notesUIImageview: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.contentMode = .scaleAspectFit
    contentView.addSubview(image)
    image.image = R.image.postIt()
    return image
  }()

  private var imageRequester: AnyCancellable?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    isSkeletonable = true
    setupUIElements()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUIElements()
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    avatarUIImageView.image = nil
    imageRequester?.cancel()
  }

  override func awakeFromNib() {
    super.awakeFromNib()
    notesUIImageview.isHidden = true
  }

  // MARK: - Show All Skeleton View
  func showSkeletalView() {
    [avatarUIImageView, usernameLabel, uriLabel].forEach { $0?.showAnimatedSkeleton() }
  }

  // MARK: - Hide All Skeleton View
  func hideSkeletalView() {
    [avatarUIImageView, usernameLabel, uriLabel].forEach { $0?.hideSkeleton() }
  }

  // MARK: - Configure Cell
  func configureCell(user: Devs, idx: Int) {
    hideSkeletalView()
    let changeColor = (idx + 1) % 4 == 0 && idx > 0

    usernameLabel.text = user.login
    uriLabel.text = user.url
    if let url = URL(string: user.avatarURL ?? .empty) {
      imageRequester = ImageLoader.shared.loadImage(from: url).sink { [weak self] image in
        guard let s = self else { return }
        if changeColor {
          s.changeImage(image: image)
        } else {
          s.avatarUIImageView.image = image
        }
      }
    }
    notesUIImageview.isHidden = !CDManager.shared.thereIsNotes(id: Int(user.id))
  }
  
  // MARK: - Invert Image Color
  private func changeImage(image: UIImage?) {
    if let filter = CIFilter(name: "CIColorInvert"),
      let image = image,
      let ciimage = CIImage(image: image) {
      filter.setValue(ciimage, forKey: kCIInputImageKey)
      let newImage = UIImage(ciImage: filter.outputImage!)
      avatarUIImageView.image = newImage
    }
  }
}

private extension DevListCell {
  // MARK: - UI Setup using Autolayout
  func setupUIElements() {
    avatarUIImageView.translatesAutoresizingMaskIntoConstraints = false
    avatarUIImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10).isActive = true
    avatarUIImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    avatarUIImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
    NSLayoutConstraint.activate([
      avatarUIImageView.widthAnchor.constraint(equalToConstant: 60),
      avatarUIImageView.heightAnchor.constraint(equalToConstant: 60)
    ])
    avatarUIImageView.cornerRadius(radius: 30)

    usernameLabel.translatesAutoresizingMaskIntoConstraints = false
    usernameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15).isActive = true
    usernameLabel.leadingAnchor.constraint(equalTo: avatarUIImageView.trailingAnchor, constant: 10).isActive = true
    NSLayoutConstraint.activate([
      usernameLabel.widthAnchor.constraint(equalToConstant: 280),
    ])

    uriLabel.translatesAutoresizingMaskIntoConstraints = false
    uriLabel.leadingAnchor.constraint(equalTo: avatarUIImageView.trailingAnchor, constant: 10).isActive = true
    uriLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10).isActive = true

    NSLayoutConstraint.activate([
      uriLabel.widthAnchor.constraint(equalToConstant: 250),
    ])
    
    notesUIImageview.translatesAutoresizingMaskIntoConstraints = false
    notesUIImageview.widthAnchor.constraint(equalToConstant: 30).isActive = true
    notesUIImageview.heightAnchor.constraint(equalToConstant: 30).isActive = true
    notesUIImageview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    notesUIImageview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
    notesUIImageview.isHidden = true
  }
}
