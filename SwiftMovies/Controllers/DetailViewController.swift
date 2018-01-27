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
      if let backdropPath = movie?.backdrop_path {
        HttpAgent.request(url: "https://image.tmdb.org/t/p/w500\(backdropPath)").responseJSON { (response) in
          guard let data = response.data else { return }
          self.backdropImageView.image = UIImage(data: data)
        }
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
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = .white
    
    backdropImageView.addSubview(backdropOverlayView)
    view.addSubview(backdropImageView)
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropOverlayView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropOverlayView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(200)]", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
  }
}
