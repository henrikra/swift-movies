//
//  MainView.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 17/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
  let movieSections: MovieSections = {
    let scrollView = MovieSections(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.tintColor = .white
    
    let gradientLayer: CAGradientLayer = CAGradientLayer()
    gradientLayer.frame = view.frame
    let myColor = UIColor(red: 75.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1.0)
    let myColor2 = UIColor(red: 14.0/255.0, green: 16.0/255.0, blue: 27.0/255.0, alpha: 1.0)
    gradientLayer.colors = [myColor.cgColor, myColor2.cgColor]
    gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
    view.layer.addSublayer(gradientLayer)
    
    movieSections.onMoviePress = goToDetailView
    view.addSubview(movieSections)
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": movieSections]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": movieSections]))
  }
  
  func goToDetailView(movie: Movie) {
    let detailViewController = DetailViewController()
    detailViewController.movie = movie
    navigationController?.pushViewController(detailViewController, animated: true)
  }
}
