//
//  FeaturedMoviesController.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 23/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class FeaturedMoviesController: UIPageViewController, UIPageViewControllerDataSource {
  var previousIndex: Int?
  var nextIndex: Int?
  var movies: [Movie]?
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    guard let pIndex = previousIndex, let nIndex = nextIndex else {
      previousIndex = (movies?.count ?? 0) - 1
      let featuredMovieController = FeaturedMovieController()
      featuredMovieController.movie = movies?[previousIndex ?? 0]
      return featuredMovieController
    }
    if pIndex == 0 {
      let newIndex = (movies?.count ?? 0) - 1
      previousIndex = newIndex
    } else {
      previousIndex = pIndex - 1
    }
    if nIndex == 0 {
      let newIndex = (movies?.count ?? 0) - 1
      nextIndex = newIndex
    } else {
      nextIndex = nIndex - 1
    }
    let featuredMovieController = FeaturedMovieController()
    featuredMovieController.movie = movies?[previousIndex ?? 0]
    return featuredMovieController
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    guard let nIndex = nextIndex, let pIndex = previousIndex else {
      nextIndex = 1
      let featuredMovieController = FeaturedMovieController()
      featuredMovieController.movie = movies?[nextIndex ?? 0]
      return featuredMovieController
    }
    if nIndex == (movies?.count ?? 0) - 1 {
      nextIndex = 0
    } else {
      nextIndex = nIndex + 1
    }
    if pIndex == (movies?.count ?? 0) - 1 {
      previousIndex = 0
    } else {
      previousIndex = pIndex + 1
    }
    let featuredMovieController = FeaturedMovieController()
    featuredMovieController.movie = movies?[nextIndex ?? 0]
    return featuredMovieController
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    dataSource = self
  }
  
  override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
