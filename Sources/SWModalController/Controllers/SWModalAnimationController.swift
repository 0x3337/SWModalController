//
//  SWModalAnimationController.swift
//  
//
//  Created by Mirsaid Patarov on 2021-10-06.
//

import UIKit

class SWModalAnimationController: NSObject {
  var mode: SWModalAnimationMode

  private var animator: UIViewPropertyAnimator!

  init(mode: SWModalAnimationMode) {
    self.mode = mode
  }
}

extension SWModalAnimationController: UIViewControllerAnimatedTransitioning {
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return 0.6
  }

  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let animator = interruptibleAnimator(using: transitionContext)
    animator.startAnimation()
  }

  func interruptibleAnimator(using transitionContext: UIViewControllerContextTransitioning) -> UIViewImplicitlyAnimating {
    if let animator = animator {
      return animator
    }

    guard let presentedViewController = transitionContext.viewController(forKey: mode.transitionKey) else {
      fatalError("Cannot find viewController for transitionKey: \(mode.transitionKey)")
    }

    let duration = transitionDuration(using: transitionContext)
    let containerView = transitionContext.containerView

    let finalFrame = transitionContext.finalFrame(for: presentedViewController)
    let initialFrame = CGRect(x: 0, y: containerView.bounds.height, width: finalFrame.width, height: finalFrame.height)

    if mode == .present {
      containerView.addSubview(presentedViewController.view)

      presentedViewController.view.frame = initialFrame
    }

    animator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) { [unowned self] in
       switch mode {
       case .present:
         presentedViewController.view.frame = finalFrame
       case .dismiss:
         presentedViewController.view.frame = initialFrame
       }
    }

    animator.addCompletion { _ in
      let finished = !transitionContext.transitionWasCancelled
      transitionContext.completeTransition(finished)

      self.animator = nil
    }

    return animator
  }
}
