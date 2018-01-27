//
//  MainView.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 17/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class MainView: UIViewController {
  let myScrollView: MovieSections = {
    let scrollView = MovieSections(collectionViewLayout: UICollectionViewFlowLayout())
    return scrollView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    gradientLayer.frame = view.frame
    let myColor = UIColor(red: 75.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    let myColor2 = UIColor(red: 14.0/255.0, green: 16.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    gradientLayer.colors = [myColor.cgColor, myColor2.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    view.layer.addSublayer(gradientLayer)
    
    if let sections = myScrollView.collectionView {
      myScrollView.onMoviePress = goToDetailView
      view.addSubview(sections)
    }
  }
  
  func goToDetailView() {
    navigationController?.pushViewController(DetailViewController(), animated: true)
  }
  
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    navigationController?.isNavigationBarHidden = true
  }
  
  override func viewDidDisappear(_ animated: Bool) {
    super.viewDidDisappear(animated)
    navigationController?.isNavigationBarHidden = false
  }
}
