//
//  SWModalInteractionController.swift
//  
//
//  Created by Mirsaid Patarov on 2021-10-06.
//

import UIKit

class SWModalInteractionController: UIPercentDrivenInteractiveTransition {
  var isInteractive = false

  private let threshold: CGFloat = 0.2
  private weak var viewController: UIViewController!

  init(viewController: UIViewController) {
    super.init()

    self.viewController = viewController
  }
}

extension SWModalInteractionController {
  @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    guard let view = gestureRecognizer.view else { return }
    guard let viewController = viewController as? SWModalController else { return }

    let translation = gestureRecognizer.translation(in: view.superview!)
    var progress = translation.y / viewController.view.bounds.height
    progress = min(max(progress, 0.0), 1.0)

    switch gestureRecognizer.state {
    case .began:
      isInteractive = true

      viewController.dismiss(animated: true, completion: nil)
    case .changed:
      isInteractive = true
      
      var scrollOffset: CGPoint = .zero

      if let scrollView = viewController.modalView as? UIScrollView {
        scrollOffset = scrollView.contentOffset
      }

      if scrollOffset.y == 0 {
        update(progress)
      } else {
        gestureRecognizer.setTranslation(.zero, in: view)
      }
    default:
      isInteractive = false

      let shouldComplete = progress > threshold
      shouldComplete ? finish() : cancel()
    }
  }
}
