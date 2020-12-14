//
//  Designables+UILabel.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/14/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class LabelDesign: UILabel {
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

  @IBInspectable var masksToBounds: Bool = true {
    didSet {
      layer.masksToBounds = masksToBounds
    }
  }

  @IBInspectable var isUnderline: Bool = false {
    didSet {
      attributedText = NSAttributedString(
        string: text ?? "", attributes:
        [.underlineStyle: NSUnderlineStyle.single.rawValue]
      )
    }
  }

  @IBInspectable var isStrikeThrough: Bool = false {
    didSet {
      let attributeString = NSMutableAttributedString(string: text ?? "")
      attributeString.addAttribute(
        NSAttributedString.Key.strikethroughStyle,
        value: 2,
        range: NSRange(location: 0, length: attributeString.length)
      )
      attributedText = attributeString
    }
  }
}
