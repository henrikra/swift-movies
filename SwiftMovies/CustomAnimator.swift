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
  let moviePosterView: UIImageView
  
  let CustomAnimatorTag = 99 // TODO figure out better way than tags
  
  init(duration: TimeInterval, isPushing: Bool, originFrame: CGRect, image: UIImage, moviePosterView: UIImageView) {
    self.duration = duration
    self.isPushing = isPushing
    self.originFrame = originFrame
    self.image = image
    self.moviePosterView = moviePosterView
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
    
    guard let posterImageView = targetView.viewWithTag(CustomAnimatorTag) as? UIImageView else { return }
    posterImageView.image = image
    posterImageView.alpha = 0
    moviePosterView.alpha = 0
    
    let currentPosterFrame = posterImageView.convert(posterImageView.frame, to: nil)
    let transitionImageView = UIImageView(frame: isPushing ? originFrame : CGRect(x: posterImageView.frame.minX, y: currentPosterFrame.minY - 100, width: 100, height: 150))
    transitionImageView.image = posterImageView.image
    containerView.addSubview(transitionImageView)
    targetView.layoutIfNeeded()
    
    targetView.frame = isPushing ? CGRect(x: fromView.frame.width, y: 0, width: targetView.frame.width, height: targetView.frame.height) : targetView.frame
    
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: [], animations: {
      transitionImageView.frame = self.isPushing ? posterImageView.frame : self.originFrame
    }) { (finished) in
      posterImageView.alpha = 1
      self.moviePosterView.alpha = 1
      transitionImageView.removeFromSuperview()
    }
    
    UIView.animate(withDuration: duration, animations: {
      targetView.frame = self.isPushing ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
    }) { (finished) in
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
  }
}
