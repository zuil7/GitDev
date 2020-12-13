//
//  UIViewcontroller+AlertMessage.swift
//  GitDev
//
//  Created by Louise Nicolas Namoc on 12/13/20.
//  Copyright © 2020 Louise Nicolas Namoc. All rights reserved.
//

import UIKit

extension UIViewController {
   
  func presentAlert(title: String, message: String,
                    okTitle: String = S.okay(),
                    cancelTitle: String = S.cancel(),
                    yesBlock: @escaping VoidResult, cancelBlock: @escaping VoidResult) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: okTitle, style: .default) { _ in
      yesBlock()
    }
    let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
      cancelBlock()
    }
    alert.addAction(cancel)
    alert.addAction(ok)
    self.present(alert, animated: true)
  }
  
  func presentAlertMessage(title: String, message: String,
                           okTitle: String = S.okay()) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: okTitle, style: .default) { _ in
    }
    alert.addAction(ok)
    self.present(alert, animated: true)
    
  }
  func presentSimpleAlert(title: String, message: String,
                          okTitle: String = S.okay(),
                          cancelTitle: String = S.cancel()) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: okTitle, style: .default) { _ in
    }
    let cancel = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
    }
    alert.addAction(cancel)
    alert.addAction(ok)
    self.present(alert, animated: true)
  }
  
  func presentAlertWithOkAction(title: String, message: String,
                                okTitle: String = S.okay(),
                                yesBlock: @escaping VoidResult) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    let ok = UIAlertAction(title: okTitle, style: .default) { _ in
      yesBlock()
    }
    alert.addAction(ok)
    self.present(alert, animated: true)
  }
  
}
