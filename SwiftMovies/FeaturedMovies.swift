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
  
  let featuredMoviesController: FeaturedMoviesController = {
    let featuredMoviesController = FeaturedMoviesController()
    featuredMoviesController.view.translatesAutoresizingMaskIntoConstraints = false
    return featuredMoviesController
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(featuredMoviesController.view)
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": featuredMoviesController.view]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": featuredMoviesController.view]))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class FeaturedMovieController: UIViewController {
  var movie: Movie? {
    didSet {
      titleLabel.text = movie?.title
      
      backdropImageView.image = nil
      posterImageView.image = nil
      
      if let backdropPath = movie?.backdrop_path {
        HttpAgent.request(url: "https://image.tmdb.org/t/p/w500\(backdropPath)").responseJSON { (response) in
          guard let data = response.data else { return }
          self.backdropImageView.image = UIImage(data: data)
        }
      }
      if let posterPath = movie?.poster_path {
        HttpAgent.request(url: "https://image.tmdb.org/t/p/w300\(posterPath)").responseJSON { (response) in
          guard let data = response.data else { return }
          self.posterImageView.image = UIImage(data: data)
        }
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
  
  let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 32)
    label.textColor = .white
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(backdropImageView)
    view.addSubview(posterImageView)
    view.addSubview(titleLabel)
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-(40)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(30)-[v0(60)]-(padding400)-[v1]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": posterImageView, "v1": titleLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(90)]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": posterImageView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-(25)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": titleLabel]))
  }
}
