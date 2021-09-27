//
//  SWModalAnimationMode.swift
//  
//
//  Created by Mirsaid Patarov on 2021-10-07.
//

import UIKit

enum SWModalAnimationMode {
  case present
  case dismiss

  var transitionKey: UITransitionContextViewControllerKey {
    switch self {
    case .present:
      return .to
    case .dismiss:
      return .from
    }
  }
}
