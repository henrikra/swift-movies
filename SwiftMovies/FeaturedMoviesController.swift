//
//  FeaturedMoviesController.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 23/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class FeaturedMoviesController: UIPageViewController, UIPageViewControllerDataSource {
  var movies: [Movie]? {
    didSet {
      pageControl.numberOfPages = movies?.count ?? 0
    }
  }
  
  let pageControl: UIPageControl = {
    let pageControl = UIPageControl()
    pageControl.translatesAutoresizingMaskIntoConstraints = false
    pageControl.currentPageIndicatorTintColor = UIColor(red: 255/255, green: 82/255, blue: 108/255, alpha: 1)
    pageControl.pageIndicatorTintColor = UIColor(white: 1, alpha: 0.5)
    pageControl.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
    return pageControl
  }()
  
  func getCurrentMovieIndex(currentViewController: FeaturedMovieController) -> Int? {
    return movies?.index(where: { $0.id == currentViewController.movie?.id })
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    let currentViewController = viewController as! FeaturedMovieController
    let currentMovieIndex = getCurrentMovieIndex(currentViewController: currentViewController)
    pageControl.currentPage = currentMovieIndex ?? 0
    
    let nextIndex = isFirstMovie(currentMovieIndex ?? 0) ? (movies?.count ?? 0) - 1 : (currentMovieIndex ?? 0) - 1
    let featuredMovieController = FeaturedMovieController()
    featuredMovieController.movie = movies?[nextIndex]
    featuredMovieController.onPress = currentViewController.onPress
    return featuredMovieController
  }
  
  private func isFirstMovie(_ index: Int) -> Bool {
    return index == 0
  }
  
  private func isLastMovie(_ index: Int) -> Bool {
    return index == (movies?.count ?? 0) - 1
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    let currentViewController = viewController as! FeaturedMovieController
    let currentMovieIndex = getCurrentMovieIndex(currentViewController: currentViewController)
    pageControl.currentPage = currentMovieIndex ?? 0
    
    let nextIndex = isLastMovie(currentMovieIndex ?? 0) ? 0 : (currentMovieIndex ?? 0) + 1
    let featuredMovieController = FeaturedMovieController()
    featuredMovieController.movie = movies?[nextIndex]
    featuredMovieController.onPress = currentViewController.onPress
    return featuredMovieController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    dataSource = self
    
    view.addSubview(pageControl)
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": pageControl]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(30)]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": pageControl]))
  }
  
  override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
