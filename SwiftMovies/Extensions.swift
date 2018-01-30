//
//  Extensions.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 30/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

extension UIView {
  func addGradientBackground(fromColor: UIColor, toColor: UIColor) {
    let gradientLayer = CAGradientLayer()
    gradientLayer.frame = bounds
    gradientLayer.colors = [fromColor.cgColor, toColor.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    layer.insertSublayer(gradientLayer, at: 0)
  }
}
