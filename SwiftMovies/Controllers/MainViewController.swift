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
  var selectedMovieImageView: UIImageView?
  var customInteractor: SpringImageInteractor?
  
  let movieSections: MovieSections = {
    let scrollView = MovieSections(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    return scrollView
  }()
  
  let searchButton: UIButton = {
    let button = UIButton(type: .system)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.backgroundColor = .white
    button.layer.cornerRadius = 30
    button.addTarget(self, action: #selector(openSearch), for: .touchUpInside)
    button.setImage(#imageLiteral(resourceName: "magnifying glass"), for: .normal)
    button.tintColor = Colors.accent500
    return button
  }()
  
  let loaderView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Colors.primary500
    return view
  }()
  
  let activityIndicatorView: UIActivityIndicatorView = {
    let activityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    activityIndicatorView.startAnimating()
    activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
    return activityIndicatorView
  }()
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
    navigationController?.delegate = self
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    UIApplication.shared.statusBarStyle = .lightContent
    
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.tintColor = .white
    
    view.addGradientBackground(fromColor: Colors.primary500, toColor: Colors.secondary500)
    
    movieSections.onMoviePress = goToDetailView
    movieSections.hideLoader = hideLoader
    view.addSubview(movieSections)
    view.addSubview(searchButton)
    view.addSubview(loaderView)
    
    loaderView.addSubview(activityIndicatorView)
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": movieSections]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": movieSections]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "[v0(60)]-padding500-|", options: [], metrics: metrics, views: ["v0": searchButton]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(60)]-padding500-|", options: [], metrics: metrics, views: ["v0": searchButton]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": loaderView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": loaderView]))
    activityIndicatorView.centerXAnchor.constraint(equalTo: loaderView.centerXAnchor).isActive = true
    activityIndicatorView.centerYAnchor.constraint(equalTo: loaderView.centerYAnchor).isActive = true
  }
  
  func hideLoader() {
    UIView.animate(withDuration: 0.75, animations: {
      self.loaderView.alpha = 0
      self.loaderView.transform = CGAffineTransform(scaleX: 2, y: 2)
    }) { (finished) in
      self.loaderView.removeFromSuperview()
    }
  }
  
  func goToDetailView(movie: Movie, originFrame: CGRect, imageView: UIImageView) {
    self.originFrame = originFrame
    self.selectedMovie = movie
    self.selectedMovieImageView = imageView
    let detailViewController = DetailViewController()
    detailViewController.movie = movie
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  @objc func openSearch() {
    navigationController?.present(UINavigationController(rootViewController: SearchViewController()), animated: true, completion: nil)
  }
  
  func navigationController(_ navigationController: UINavigationController, animationControllerFor operation: UINavigationControllerOperation, from fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
    if toVC is ActorDetailViewController {
      return nil
    }
    if fromVC is ActorDetailViewController && toVC is DetailViewController {
      return nil
    }
    
    guard let originFrame = originFrame, let imageView = selectedMovieImageView else { return nil }
    
    switch operation {
      case .push:
        self.customInteractor = SpringImageInteractor(attachTo: toVC)
        return SpringImageTransition(duration: 0.5, isPushing: true, originFrame: originFrame, moviePosterView: imageView)
      default:
        return SpringImageTransition(duration: 0.5, isPushing: false, originFrame: originFrame, moviePosterView: imageView)
    }
  }
  
  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    guard let customInteractor = customInteractor else { return nil }
    return customInteractor.transitionInProgress ? customInteractor : nil
  }
}
