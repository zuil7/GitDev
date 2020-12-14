//
//  Designables+Button.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/14/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable
class ButtonDesign: UIButton {
  
  @IBInspectable
  public var width: CGFloat = 0.5 {
    didSet {
      self.layer.borderWidth = width
    }
  }
  
  @IBInspectable
  public var radius: CGFloat = 0.5 {
    didSet {
      self.layer.cornerRadius = radius
    }
  }
  
  @IBInspectable
  public var bColor: UIColor = UIColor.black {
    didSet {
      self.layer.borderColor = bColor.cgColor
    }
  }
  
  @IBInspectable var shadow: UIColor = UIColor.gray {
    didSet {
      layer.shadowColor = shadow.cgColor
    }
  }
  
  @IBInspectable var shadowOpacity: Float = 1.0 {
    didSet {
      layer.shadowOpacity = shadowOpacity
    }
  }
  
  @IBInspectable var shadowRadius: CGFloat = 1.0 {
    didSet {
      layer.shadowRadius = shadowRadius
    }
  }
  
  @IBInspectable var masksToBounds: Bool = true {
    didSet {
      layer.masksToBounds = masksToBounds
    }
  }
  
  @IBInspectable var shadowOffset: CGSize = CGSize(width: 12, height: 12) {
    didSet {
      layer.shadowOffset = shadowOffset
    }
  }
}
