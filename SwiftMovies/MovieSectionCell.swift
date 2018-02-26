//
//  MovieSectionItem.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 25/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class MovieSectionCell: UICollectionViewCell {
  var movie: Movie? {
    didSet {
      titleLabel.text = movie?.title
      guard
        let posterPath = movie?.poster_path,
        let imageUrl = movieApi?.generateImageUrl(path: posterPath) else { return }
      posterImageView.setImage(with: imageUrl, tag: movie?.id)
    }
  }
  var movieApi: MovieApi?
  
  let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.numberOfLines = 1
    label.font = UIFont.systemFont(ofSize: 14)
    label.textColor = Colors.lightTextPrimary
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(posterImageView)
    addSubview(titleLabel)
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: nil, views: ["v0": titleLabel]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: nil, views: ["v0": posterImageView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[poster][title(60)]|", options: [], metrics: nil, views: ["poster": posterImageView, "title": titleLabel]))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
