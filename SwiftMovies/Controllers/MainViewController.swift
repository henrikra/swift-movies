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
    
    UIApplication.shared.statusBarStyle = .lightContent
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.tintColor = .white
    
    view.addGradientBackground(fromColor: Colors.primary500, toColor: Colors.secondary500)
    
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
