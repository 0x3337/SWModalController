//
//  UIColor+custom.swift
//  
//
//  Created by Mirsaid Patarov on 2021-10-09.
//

import UIKit

extension UIColor {
  static var customDim: UIColor = {
    let white = UIColor(white: 1, alpha: 0.05)
    let black = UIColor(white: 0, alpha: 0.4)

    if #available(iOS 13, *) {
      return UIColor { traitCollection in
        if traitCollection.userInterfaceStyle == .dark {
          return white
        } else {
          return black
        }
      }
    }

    return black
  }()
}
