//
//  MainView.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 17/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class MainView: UIViewController {
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    gradientLayer.frame.size = view.frame.size
    let myColor = UIColor(red: 75.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    let myColor2 = UIColor(red: 14.0/255.0, green: 16.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    gradientLayer.colors = [myColor.cgColor, myColor2.cgColor]
    view.layer.addSublayer(gradientLayer)
  }
}
