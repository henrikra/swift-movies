//
//  CustomAnimator.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 06/02/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class CustomAnimator: NSObject, UIViewControllerAnimatedTransitioning {
  let duration: TimeInterval
  let isPushing: Bool
  let originFrame: CGRect
  let image: UIImage
  
  init(duration: TimeInterval, isPushing: Bool, originFrame: CGRect, image: UIImage) {
    self.duration = duration
    self.isPushing = isPushing
    self.originFrame = originFrame
    self.image = image
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    guard
      let fromView = transitionContext.view(forKey: UITransitionContextViewKey.from),
      let toView = transitionContext.view(forKey: UITransitionContextViewKey.to) else { return }
    
    isPushing ? containerView.addSubview(toView) : containerView.insertSubview(toView, belowSubview: fromView)
    
    let targetView = isPushing ? toView : fromView
    
    targetView.frame = isPushing ? CGRect(x: fromView.frame.width, y: 0, width: targetView.frame.width, height: targetView.frame.height) : targetView.frame
    
    UIView.animate(withDuration: duration, animations: {
      targetView.frame = self.isPushing ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
    }) { (finished) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}
