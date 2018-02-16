//
//  CustomAnimator.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 06/02/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class SpringImageTransition: NSObject, UIViewControllerAnimatedTransitioning {
  let duration: TimeInterval
  let isPushing: Bool
  let originFrame: CGRect
  let moviePosterView: UIImageView
  
  init(duration: TimeInterval, isPushing: Bool, originFrame: CGRect, moviePosterView: UIImageView) {
    self.duration = duration
    self.isPushing = isPushing
    self.originFrame = originFrame
    self.moviePosterView = moviePosterView
  }
  
  func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
    return duration
  }
  
  func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
    let containerView = transitionContext.containerView
    guard
      let fromView = transitionContext.view(forKey: .from),
      let toView = transitionContext.view(forKey: .to),
      let fromViewController = transitionContext.viewController(forKey: .from),
      let toViewController = transitionContext.viewController(forKey: .to) else { return }
    
    isPushing ? containerView.addSubview(toView) : containerView.insertSubview(toView, belowSubview: fromView)
    
    let targetView = isPushing ? toView : fromView
    let targetViewController = isPushing ? toViewController : fromViewController
    
    guard let posterImageView = (targetViewController as? DetailViewController)?.posterImageView else { return }
    posterImageView.image = moviePosterView.image
    posterImageView.alpha = 0
    moviePosterView.alpha = 0
    
    let transitionImageView = UIImageView(frame: isPushing ? originFrame : posterImageView.convert(posterImageView.bounds, to: nil))
    transitionImageView.image = posterImageView.image
    transitionImageView.layer.shadowColor = UIColor.black.cgColor
    transitionImageView.layer.shadowOpacity = isPushing ? 0 : 0.2
    transitionImageView.layer.shadowOffset = CGSize(width: 10, height: 10)
    transitionImageView.layer.shadowRadius = 0

    let playIconSize: CGFloat = isPushing ? moviePosterView.frame.width / 3.5 : posterImageView.frame.width / 3.5
    let playIcon = PlayIconView()
    playIcon.layer.shadowColor = UIColor.black.cgColor
    playIcon.layer.shadowOffset = CGSize(width: 0, height: 0)
    playIcon.layer.shadowRadius = 5
    playIcon.layer.shadowOpacity = 0.7
    playIcon.backgroundColor = .clear
    transitionImageView.addSubview(playIcon)
    playIcon.frame = CGRect(x: transitionImageView.frame.width / 2 - playIconSize / 2, y: transitionImageView.frame.height / 2 - playIconSize / 2, width: playIconSize, height: playIconSize)
    playIcon.alpha = isPushing ? 0 : 1
    containerView.addSubview(transitionImageView)
    targetView.layoutIfNeeded()
    
    targetView.frame = isPushing ? CGRect(x: fromView.frame.width, y: 0, width: targetView.frame.width, height: targetView.frame.height) : targetView.frame
    
    
    let shadowAnimation = CABasicAnimation(keyPath: "shadowOpacity")
    shadowAnimation.fromValue = transitionImageView.layer.shadowOpacity
    shadowAnimation.toValue = isPushing ? 0.2 : 0
    shadowAnimation.duration = duration
    transitionImageView.layer.add(shadowAnimation, forKey: shadowAnimation.keyPath)
    transitionImageView.layer.shadowOpacity = isPushing ? 0.2 : 0
    UIView.animate(withDuration: duration, delay: 0.1, usingSpringWithDamping: 0.75, initialSpringVelocity: 0.5, options: [], animations: {
      transitionImageView.frame = self.isPushing ? posterImageView.frame : self.originFrame
      playIcon.alpha = self.isPushing ? 1 : 0
      let newPlayIconSize = self.isPushing ? posterImageView.frame.width / 3.5 : self.moviePosterView.frame.width / 3.5
      playIcon.frame = self.isPushing ? CGRect(x: posterImageView.frame.width / 2 - newPlayIconSize / 2, y: posterImageView.frame.height / 2 - newPlayIconSize / 2, width: newPlayIconSize, height: newPlayIconSize) : CGRect(x: self.moviePosterView.frame.width / 2 - newPlayIconSize / 2, y: self.moviePosterView.frame.height / 2 - newPlayIconSize / 2, width: newPlayIconSize, height: newPlayIconSize)
    }) { (finished) in
      transitionImageView.removeFromSuperview()
      posterImageView.alpha = 1
      self.moviePosterView.alpha = 1
      transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
    }
    
    UIView.animate(withDuration: duration, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: {
      targetView.frame = self.isPushing ? fromView.frame : CGRect(x: toView.frame.width, y: 0, width: toView.frame.width, height: toView.frame.height)
    })
  }
}
