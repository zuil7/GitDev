//
//  DevListCell.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Combine
import UIKit

class DevListCell: UITableViewCell {
  lazy var avatarUIImageView: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.backgroundColor = .lightGray
    contentView.addSubview(image)
    return image
  }()

  lazy var usernameLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    label.font = .boldSystemFont(ofSize: 16)
    label.text = "Test"
    contentView.addSubview(label)
    return label
  }()

  lazy var uriLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.font = .boldSystemFont(ofSize: 16)
    label.text = "Test"
    contentView.addSubview(label)
    return label
  }()

  lazy var notesUIImageview: UIImageView = {
    let image = UIImageView()
    image.translatesAutoresizingMaskIntoConstraints = false
    image.backgroundColor = .red
    contentView.addSubview(image)
    return image
  }()

  private var cancellable: AnyCancellable?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUIElements()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setupUIElements()
  }

  public override func prepareForReuse() {
    super.prepareForReuse()
    avatarUIImageView.image = nil
    cancellable?.cancel()
  }

  func configureCell(user: DevListResponseElement) {
    usernameLabel.text = user.login
    uriLabel.text = user.url
    if let url = URL(string: user.avatarURL) {
      cancellable = ImageLoader.shared.loadImage(from: url).sink { [weak self] image in
        guard let s = self else { return }
        s.avatarUIImageView.image = image
      }
    }
  }
}

private extension DevListCell {
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

    uriLabel.translatesAutoresizingMaskIntoConstraints = false
    uriLabel.leadingAnchor.constraint(equalTo: avatarUIImageView.trailingAnchor, constant: 10).isActive = true
    uriLabel.topAnchor.constraint(equalTo: usernameLabel.bottomAnchor, constant: 10).isActive = true

    notesUIImageview.translatesAutoresizingMaskIntoConstraints = false
    notesUIImageview.widthAnchor.constraint(equalToConstant: 30).isActive = true
    notesUIImageview.heightAnchor.constraint(equalToConstant: 30).isActive = true
    notesUIImageview.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
    notesUIImageview.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20).isActive = true
  }
}
