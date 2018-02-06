//
//  FeaturedMovies.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 22/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class FeaturedMovies: UICollectionViewCell {
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
  var onPress: ((Movie, CGRect, UIImage, UIImageView) -> Void)?
  var movie: Movie? {
    didSet {
      titleLabel.text = movie?.title
      subtitleLabel.text = movie?.release_date
      
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
  
  let backdropOverlayView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor(white: 0, alpha: 0.2)
    return view
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
    label.font = UIFont.boldSystemFont(ofSize: 30)
    label.textColor = .white
    return label
  }()
  
  let subtitleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor(white: 1, alpha: 0.7)
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  
  let textContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  @objc func handleTap() {
    if let movie = movie {
      onPress?(movie, .zero, UIImage(), UIImageView())
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addSubview(backdropImageView)
    backdropImageView.addSubview(backdropOverlayView)
    view.addSubview(posterImageView)
    view.addSubview(textContainerView)
    textContainerView.addSubview(titleLabel)
    textContainerView.addSubview(subtitleLabel)
    
    view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-(60)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropOverlayView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropOverlayView]))
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(30)-[v0(60)]-(padding400)-[v1]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": posterImageView, "v1": textContainerView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(90)]-(25)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": posterImageView]))
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(52)]-(30)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": textContainerView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": titleLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": subtitleLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-(3)-[v1]", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": titleLabel, "v1": subtitleLabel]))
  }
}
