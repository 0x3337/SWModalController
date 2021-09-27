//
//  SWModalController.swift
//
//
//  Created by Mirsaid Patarov on 2021-09-27.
//

import UIKit

open class SWModalController: UIViewController {
  open var panGestureRecognizer: UIPanGestureRecognizer!

  open var modalView: UIView {
    return view
  }

  override open var preferredStatusBarStyle: UIStatusBarStyle {
    return .lightContent
  }

  private var interactionController: SWModalInteractionController!

  override public init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)

    transitioningDelegate = self

    modalPresentationStyle = .custom
    modalPresentationCapturesStatusBarAppearance = true
  }

  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override open func viewDidLoad() {
    super.viewDidLoad()

    interactionController = SWModalInteractionController(viewController: self)

    panGestureRecognizer = UIPanGestureRecognizer(target: interactionController, action: #selector(interactionController.handlePanGesture(_:)))
    panGestureRecognizer.delegate = self
    panGestureRecognizer.maximumNumberOfTouches = 1
    panGestureRecognizer.cancelsTouchesInView = false

    modalView.addGestureRecognizer(panGestureRecognizer)
  }
}

extension SWModalController: UIViewControllerTransitioningDelegate {
  public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
    return SWModalPresentationController(presentedViewController: presented, presenting: presenting)
  }

  public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SWModalAnimationController(mode: .present)
  }

  public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    return SWModalAnimationController(mode: .dismiss)
  }

  public func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return interactionController.isInteractive ? interactionController : nil
  }
}

extension SWModalController: UIGestureRecognizerDelegate {
  public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
    return gestureRecognizer == panGestureRecognizer && otherGestureRecognizer.view == modalView
  }
}
