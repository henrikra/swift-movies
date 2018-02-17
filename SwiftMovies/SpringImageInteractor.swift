//
//  CustomInteractor.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 08/02/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class SpringImageInteractor: UIPercentDrivenInteractiveTransition {
  let navigationController: UINavigationController
  var shouldCompleteTransition = false
  var transitionInProgress = false
  
  init?(attachTo viewController: UIViewController) {
    if let nav = viewController.navigationController {
      navigationController = nav
      super.init()
      setupBackGesture(view: viewController.view)
    } else {
      return nil
    }
  }
  
  private func setupBackGesture(view: UIView) {
    let swipeBackGesture = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(handleBackGesture(_:)))
    swipeBackGesture.edges = .left
    view.addGestureRecognizer(swipeBackGesture)
  }
  
  @objc private func handleBackGesture(_ gesture : UIScreenEdgePanGestureRecognizer) {
    let viewTranslation = gesture.translation(in: gesture.view?.superview)
    let progress = viewTranslation.x / navigationController.view.frame.width
    
    switch gesture.state {
      case .began:
        transitionInProgress = true
        navigationController.popViewController(animated: true)
        break
      case .changed:
        shouldCompleteTransition = progress > 0.3
        let value = pow(viewTranslation.x, 1.3) / pow(navigationController.view.frame.width, 1.3)
        update(value.isNaN ? 0 : value / 2.5)
        break
      case .cancelled:
        transitionInProgress = false
        cancel()
        break
      case .ended:
        transitionInProgress = false
        shouldCompleteTransition ? finish() : cancel()
        break
      default:
        return
    }
  }
}
