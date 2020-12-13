//
//  UIImageView+CornerRadius.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import UIKit

extension UIImageView {
  func cornerRadius(radius: CGFloat? = nil) {
    layer.cornerRadius = radius ?? frame.width / 2
    layer.masksToBounds = true
  }
}
