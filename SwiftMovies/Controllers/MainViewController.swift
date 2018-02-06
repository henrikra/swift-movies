//
//  MainView.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 17/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UINavigationControllerDelegate {
  var originFrame: CGRect?
  var selectedMovie: Movie?
  var selectedImage: UIImage?
  let movieSections: MovieSections = {
    let scrollView = MovieSections(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    navigationController?.delegate = self
    
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
  
  func goToDetailView(movie: Movie, originFrame: CGRect, image: UIImage) {
    self.originFrame = originFrame
    self.selectedMovie = movie
    self.selectedImage = image
    let detailViewController = DetailViewController()
    detailViewController.movie = movie
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    guard let originFrame = originFrame, let image = selectedImage else { return nil }
    
    switch operation {
      case .push:
        return CustomAnimator(duration: 1.0, isPushing: true, originFrame: originFrame, image: image)
      default:
        return CustomAnimator(duration: 1.0, isPushing: false, originFrame: originFrame, image: image)
    }
  }
}
