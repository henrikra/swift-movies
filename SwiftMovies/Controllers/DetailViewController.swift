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
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  let backdropOverlayView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let movieInfoView: TouchesOutsideView = {
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
  
  let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
    return scrollView
  }()
  
  var idlePosterImageViewTopAnchor: NSLayoutConstraint?
  var idlePosterImageViewHeightAnchor: NSLayoutConstraint?
  var activePosterImageViewHeightAnchor: NSLayoutConstraint?
  var activePosterImageViewCenterYAnchor: NSLayoutConstraint?
  var isPosterActive = false
  
  let directorLabel: UILabel = {
    let label = UILabel()
    label.text = "DIRECTOR"
    label.textColor = UIColor(white: 1, alpha: 0.7)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  
  let directorNameLabel: UILabel = {
    let label = UILabel()
    label.text = "Rian Johnson"
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 14)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.secondary500
    
    view.addSubview(scrollView)

    let content = UIStackView(arrangedSubviews: [backdropImageView, movieInfoView])
    content.axis = .vertical
    content.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(content)
    
    scrollView.alwaysBounceVertical = true
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": scrollView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": scrollView]))
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": content]))
    
    content.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    let heightConstraint = content.heightAnchor.constraint(equalTo: view.heightAnchor)
    heightConstraint.priority = UILayoutPriority(250)
    heightConstraint.isActive = true
    
    movieInfoView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(togglePosterZoom)))
    
    backdropImageView.addSubview(backdropOverlayView)
    movieInfoView.addSubview(titleLabel)
    movieInfoView.addSubview(overviewLabel)
    movieInfoView.addSubview(posterImageView)
    movieInfoView.addSubview(directorLabel)
    movieInfoView.addSubview(directorNameLabel)
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropOverlayView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropOverlayView]))
    backdropImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    
    posterImageView.centerXAnchor.constraint(equalTo: movieInfoView.centerXAnchor, constant: 0).isActive = true
    activePosterImageViewCenterYAnchor = posterImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
    idlePosterImageViewTopAnchor = posterImageView.topAnchor.constraint(equalTo: movieInfoView.topAnchor, constant: -100)
    idlePosterImageViewHeightAnchor = posterImageView.heightAnchor.constraint(equalToConstant: 150)
    activePosterImageViewHeightAnchor = posterImageView.heightAnchor.constraint(equalToConstant: 300)

    idlePosterImageViewTopAnchor?.isActive = true
    idlePosterImageViewHeightAnchor?.isActive = true

    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": titleLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": overviewLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[v0]-(padding500)-[v1]-(padding500)-[v2]-(padding300)-[v3]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": titleLabel, "v1": overviewLabel, "v2": directorLabel, "v3": directorNameLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": directorLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": directorNameLabel]))
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    movieInfoView.addGradientBackground(fromColor: Colors.primary500, toColor: Colors.secondary500)
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
