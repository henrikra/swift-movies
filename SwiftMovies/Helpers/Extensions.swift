//
//  Extensions.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 30/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

extension UIView {
  func addGradientBackground(fromColor: UIColor, toColor: UIColor, startPoint: CGPoint = CGPoint(x: 0, y: 0), endPoint: CGPoint = CGPoint(x: 1, y: 1)) -> CAGradientLayer {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
    gradientLayer.startPoint = startPoint
    gradientLayer.endPoint = endPoint
    layer.insertSublayer(gradientLayer, at: 0)
    return gradientLayer
  }
}

extension UIImageView {
  func setImage(with url: String) {
    image = nil
    alpha = 0
    
    HttpAgent.request(url: url).responseJSON { (response) in
      guard let data = response.data else { return }
      self.image = UIImage(data: data)
      if response.isFromCache {
        self.alpha = 1
      } else {
        UIView.animate(withDuration: 0.5, animations: {
          self.alpha = 1
        })
      }
    }
  }
}
