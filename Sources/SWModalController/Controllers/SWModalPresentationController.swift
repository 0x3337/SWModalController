//
//  SWModalPresentationController.swift
//  
//
//  Created by Mirsaid Patarov on 2021-09-27.
//

import UIKit

class SWModalPresentationController: UIPresentationController {
  var presentingView: UIView {
    return presentingViewController.view
  }

  lazy var dimmingView: UIView = {
    let view = UIView(frame: UIScreen.main.bounds)
    view.alpha = 0
    view.backgroundColor = .customDim

    return view
  }()

  lazy var dismissingView: UIView = {
    let view = UIView(frame: UIScreen.main.bounds)
    view.backgroundColor = .clear
    view.addGestureRecognizer(tapGestureRecognizer)

    return view
  }()

  var scaleFactor: CGFloat = 0.915
  var cornerRadius: CGFloat = 10

  var maxCornerRadius: CGFloat {
    if hasSubmodal {
      return cornerRadius
    }

    return UIDevice.current.hasNotch ? 40 : 0
  }

  var hasSubmodal: Bool {
    return presentingViewController.presentationController is SWModalPresentationController
  }

  var tapGestureRecognizer: UITapGestureRecognizer {
    let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture(_:)))
    gestureRecognizer.cancelsTouchesInView = false

    return gestureRecognizer
  }

  private var initialFrame: CGRect = .zero

  override func containerViewDidLayoutSubviews() {
    super.containerViewDidLayoutSubviews()

    if let presentedView = presentedView, presentedView.transform == .identity {
      presentedView.frame = frameOfPresentedViewInContainerView
    }
  }

  override var frameOfPresentedViewInContainerView: CGRect {
    guard let window = UIApplication.shared.keyWindow else { return .zero }
    guard let containerView = containerView else { return .zero }

    let preferredContentSize = presentedViewController.preferredContentSize
    let preferredHeight = preferredContentSize.height + window.safeAreaInsets.bottom

    let offset = window.safeAreaInsets.top + cornerRadius
    var frame = containerView.bounds
    frame.origin.y = offset
    frame.size.height -= offset

    if preferredContentSize != .zero && preferredHeight < frame.height {
      let preferredOffet = frame.height - preferredHeight
      frame.origin.y += preferredOffet
      frame.size.height = preferredHeight
    }

    return frame
  }

  override func presentationTransitionWillBegin() {
    super.presentationTransitionWillBegin()

    guard let presentedView = presentedView else { return }

    containerView?.insertSubview(dismissingView, aboveSubview: presentedView)

    initialFrame = presentingView.frame

    presentingView.insetsLayoutMarginsFromSafeArea = false
    presentingView.layer.masksToBounds = true
    presentingView.layer.cornerRadius = maxCornerRadius

    presentingView.addSubview(dimmingView)
    presentingView.addGestureRecognizer(tapGestureRecognizer)

    presentedView.layer.cornerRadius = cornerRadius
    presentedView.layer.masksToBounds = true
    presentedView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

    presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
      let translationY: CGFloat = UIDevice.current.hasNotch ? cornerRadius : -4

      presentingView.frame = UIScreen.main.bounds
      presentingView.layer.cornerRadius = cornerRadius
      presentingView.transform = CGAffineTransform.identity
        .translatedBy(x: 0, y: translationY)
        .scaledBy(x: scaleFactor, y: scaleFactor)

      dimmingView.alpha = 1
    }, completion: nil)
  }

  override func presentationTransitionDidEnd(_ completed: Bool) {
    super.presentationTransitionDidEnd(completed)
  }

  override func dismissalTransitionWillBegin() {
    super.dismissalTransitionWillBegin()

    presentingViewController.transitionCoordinator?.animate(alongsideTransition: { [unowned self] _ in
      presentingView.transform = .identity
      presentingView.layer.cornerRadius = maxCornerRadius
      presentingView.frame = initialFrame

      dimmingView.alpha = 0
    }, completion: nil)
  }

  override func dismissalTransitionDidEnd(_ completed: Bool) {
    super.dismissalTransitionDidEnd(completed)

    if completed {
      presentingView.layer.cornerRadius = hasSubmodal ? cornerRadius : 0

      dimmingView.removeFromSuperview()
      dismissingView.removeFromSuperview()
    }
  }
}

extension SWModalPresentationController {
  @objc func handleTapGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
    presentedViewController.dismiss(animated: true)
  }
}
