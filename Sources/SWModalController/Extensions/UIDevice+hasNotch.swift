//
//  UIDevice+hasNotch.swift
//  
//
//  Created by Mirsaid Patarov on 2021-09-27.
//

import UIKit

extension UIDevice {
  var hasNotch: Bool {
    let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0
    return bottom > 0
  }
}
