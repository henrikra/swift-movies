//
//  FeaturedMovies.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 22/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class FeaturedMovies: UICollectionViewCell {
  var movies: [Movie]?
  
  let pages: FeaturedMoviesController = {
    let pageViewController = FeaturedMoviesController()
    pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
    return pageViewController
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    let featuredMovieController = FeaturedMovie()
    featuredMovieController.movie = movies?.first
    let viewControllers = [featuredMovieController]
    pages.setViewControllers(viewControllers, direction: .forward, animated: true, completion: nil)
    
    addSubview(pages.view)
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": pages.view]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": pages.view]))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class FeaturedMovie: UIViewController {
  var movie: Movie? {
    didSet {
      backdropImageView.image = nil
      
      guard let backdropPath = movie?.backdrop_path else { return }
      HttpAgent.request(url: "https://image.tmdb.org/t/p/w500\(backdropPath)").responseJSON { (response) in
        guard let data = response.data else { return }
        let image = UIImage(data: data)
        self.backdropImageView.image = image
      }
    }
  }
  
  let backdropImageView: UIImageView = {
    let backdrop = UIImageView()
    backdrop.translatesAutoresizingMaskIntoConstraints = false
    backdrop.layer.cornerRadius = 5
    backdrop.layer.masksToBounds = true
    return backdrop
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(backdropImageView)
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
  }
}
