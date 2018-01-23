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
    let featuredMoviesController = FeaturedMoviesController()
    featuredMoviesController.view.translatesAutoresizingMaskIntoConstraints = false
    return featuredMoviesController
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(pages.view)
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": pages.view]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": pages.view]))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class FeaturedMovieController: UIViewController {
  var movie: Movie? {
    didSet {
      backdropImageView.image = nil
      
      guard let backdropPath = movie?.backdrop_path else { return }
      HttpAgent.request(url: "https://image.tmdb.org/t/p/w500\(backdropPath)").responseJSON { (response) in
        guard let data = response.data else { return }
        self.backdropImageView.image = UIImage(data: data)
      }
    }
  }
  
  let backdropImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.layer.cornerRadius = 5
    imageView.layer.masksToBounds = true
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(backdropImageView)
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
  }
}
