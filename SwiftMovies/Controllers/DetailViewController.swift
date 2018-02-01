//
//  DetailViewController.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 27/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
  var movie: Movie? {
    didSet {
      titleLabel.text = movie?.title
      overviewLabel.text = movie?.overview
      
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
      
      if let id = movie?.id {
        HttpAgent.request(url: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)").responseJSON(onReady: { (response) in
          guard let data = response.data else { return }
          do {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            print(movie.genres)
          } catch let jsonError {
            print(jsonError)
          }
        })
      }
    }
  }
  
  let backdropImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let backdropOverlayView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let contentView: TouchesOutsideView = {
    let view = TouchesOutsideView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.isUserInteractionEnabled = true
    imageView.contentMode = .scaleAspectFit
    imageView.layer.shadowColor = UIColor.black.cgColor
    imageView.layer.shadowOpacity = 0.2
    imageView.layer.shadowOffset = CGSize(width: 10, height: 10)
    imageView.layer.shadowRadius = 0
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 22)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  
  let overviewLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    return label
  }()
  
  @objc func togglePosterZoom() {
    if isPosterActive {
      activePosterImageViewHeightAnchor?.isActive = false
      activePosterImageViewCenterYAnchor?.isActive = false
      idlePosterImageViewTopAnchor?.isActive = true
      idlePosterImageViewHeightAnchor?.isActive = true
    } else {
      idlePosterImageViewTopAnchor?.isActive = false
      idlePosterImageViewHeightAnchor?.isActive = false
      activePosterImageViewCenterYAnchor?.isActive = true
      activePosterImageViewHeightAnchor?.isActive = true
    }
    
    isPosterActive = !isPosterActive
    
    UIView.animate(withDuration: 0.5) {
      self.view.layoutIfNeeded()
    }
  }
  
  var idlePosterImageViewTopAnchor: NSLayoutConstraint?
  var idlePosterImageViewHeightAnchor: NSLayoutConstraint?
  var activePosterImageViewHeightAnchor: NSLayoutConstraint?
  var activePosterImageViewCenterYAnchor: NSLayoutConstraint?
  var isPosterActive = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(togglePosterZoom)))
    
    backdropImageView.addSubview(backdropOverlayView)
    view.addSubview(backdropImageView)
    contentView.addSubview(titleLabel)
    contentView.addSubview(overviewLabel)
    contentView.addSubview(posterImageView)
    view.addSubview(contentView)
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropOverlayView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropOverlayView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(200)][v1]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView, "v1": contentView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": contentView]))
    
    posterImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
    activePosterImageViewCenterYAnchor = posterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
    idlePosterImageViewTopAnchor = posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: -100)
    idlePosterImageViewHeightAnchor = posterImageView.heightAnchor.constraint(equalToConstant: 150)
    activePosterImageViewHeightAnchor = posterImageView.heightAnchor.constraint(equalToConstant: 300)
    
    idlePosterImageViewTopAnchor?.isActive = true
    idlePosterImageViewHeightAnchor?.isActive = true
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": titleLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": overviewLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[v1]-(padding500)-[v2]", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v1": titleLabel, "v2": overviewLabel]))
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    contentView.addGradientBackground(fromColor: Colors.primary500, toColor: Colors.secondary500)
  }
}

class TouchesOutsideView: UIView {
  override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
    for subview in subviews.reversed() {
      let subPoint = subview.convert(point, from: self)
      if let result = subview.hitTest(subPoint, with: event) {
        return result
      }
    }
    return nil
  }
}
