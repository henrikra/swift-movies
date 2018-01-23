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
  var movies: [Movie]? {
    didSet {
      pageControl.numberOfPages = movies?.count ?? 0
    }
  }
  
  let pageControl: UIPageControl = {
    let pageControl = UIPageControl(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    return pageControl
  }()
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
    setPageCurrentPage(viewController: viewController)
    guard let pIndex = previousIndex, let nIndex = nextIndex else {
      previousIndex = (movies?.count ?? 0) - 1
      let featuredMovieController = FeaturedMovieController()
      featuredMovieController.movie = movies?[previousIndex ?? 0]
      return featuredMovieController
    }
    if isFirstMovie(pIndex) {
      previousIndex = (movies?.count ?? 0) - 1
    } else {
      previousIndex = pIndex - 1
    }
    if isFirstMovie(nIndex) {
      nextIndex = (movies?.count ?? 0) - 1
    } else {
      nextIndex = nIndex - 1
    }
    let featuredMovieController = FeaturedMovieController()
    featuredMovieController.movie = movies?[previousIndex ?? 0]
    return featuredMovieController
  }
  
  private func isFirstMovie(_ index: Int) -> Bool {
    return index == 0
  }
  
  private func isLastMovie(_ index: Int) -> Bool {
    return index == (movies?.count ?? 0) - 1
  }
  
  private func setPageCurrentPage(viewController: UIViewController) {
    let currentViewController = viewController as! FeaturedMovieController
    let currentMovieIndex = movies?.index(where: { (movie) -> Bool in
      movie.id == currentViewController.movie?.id
    })
    pageControl.currentPage = currentMovieIndex ?? 0
  }
  
  func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
    setPageCurrentPage(viewController: viewController)
    guard let nIndex = nextIndex, let pIndex = previousIndex else {
      nextIndex = 1
      let featuredMovieController = FeaturedMovieController()
      featuredMovieController.movie = movies?[nextIndex ?? 0]
      return featuredMovieController
    }
    if isLastMovie(nIndex) {
      nextIndex = 0
    } else {
      nextIndex = nIndex + 1
    }
    if isLastMovie(pIndex) {
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
    
    view.addSubview(pageControl)
  }
  
  override init(transitionStyle style: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation, options: [String : Any]? = nil) {
    super.init(transitionStyle: .scroll, navigationOrientation: navigationOrientation, options: options)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
