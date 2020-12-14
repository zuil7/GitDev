//
//  Designables+UIView.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/14/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ViewDesign: UIView {
  @IBInspectable
  public var borderWidth: CGFloat = 0.5 {
    didSet {
      layer.borderWidth = borderWidth
      clipsToBounds = true
    }
  }

  @IBInspectable
  public var cornerRadius: CGFloat = 0.5 {
    didSet {
      layer.cornerRadius = cornerRadius
      clipsToBounds = true
    }
  }

  @IBInspectable
  public var bColor: UIColor = UIColor.white {
    didSet {
      layer.borderColor = bColor.cgColor
      clipsToBounds = true
    }
  }

  @IBInspectable
  public var shadow: UIColor = UIColor.black {
    didSet {
      layer.shadowColor = shadow.cgColor
      clipsToBounds = true
    }
  }

  @IBInspectable
  public var shadowOpacity: Float = 0.0 {
    didSet {
      layer.shadowOpacity = shadowOpacity
      layer.masksToBounds = false
    }
  }

  @IBInspectable
  public var shadowRadius: CGFloat = 0.0 {
    didSet {
      layer.shadowRadius = shadowRadius
      layer.masksToBounds = false
    }
  }

  @IBInspectable var masksToBounds: Bool = true {
    didSet {
      layer.masksToBounds = masksToBounds
    }
  }

  @IBInspectable public var shadowOffset: CGSize = CGSize(width: 0.0, height: 0.0) {
    didSet {
      layer.shadowOffset = shadowOffset
    }
  }
}
