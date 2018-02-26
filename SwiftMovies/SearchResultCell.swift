//
//  SearchResultCell.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 26/02/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class SearchResultCell: UITableViewCell {
  var movie: Movie? {
    didSet {
      titleLabel.text = movie?.title
      if let releaseYear = movie?.release_date?.split(separator: "-").first {
        releaseDateLabel.text = String(releaseYear)
      }
      
      if let posterPath = movie?.poster_path, let imageUrl = movieApi?.generateImageUrl(path: posterPath, size: .w92) {
        posterImageView.setImage(with: imageUrl, tag: movie?.id)
      }
    }
  }
  var movieApi: MovieApi?
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = Colors.lightTextPrimary
    label.font = UIFont.boldSystemFont(ofSize: 20)
    return label
  }()
  
  let releaseDateLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.lightTextSecondary
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = Colors.lightTextDivider
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let textContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(posterImageView)
    addSubview(textContainerView)
    textContainerView.addSubview(titleLabel)
    textContainerView.addSubview(releaseDateLabel)
    addSubview(separatorView)
    selectionStyle = .none
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-padding500-[v0(30)]-padding500-[v1]|", options: [], metrics: metrics, views:
      ["v0": posterImageView, "v1": textContainerView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1(1)]|", options: [], metrics: metrics, views:
      ["v0": textContainerView, "v1": separatorView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": posterImageView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]-padding400-|", options: [], metrics: metrics, views: ["v0": titleLabel]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": releaseDateLabel]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-70-[v0]|", options: [], metrics: metrics, views: ["v0": separatorView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding500-[v0]-padding300-[v1]-padding500-|", options: [], metrics: metrics, views: ["v0": titleLabel, "v1": releaseDateLabel]))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
