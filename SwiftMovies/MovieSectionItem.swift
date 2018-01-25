//
//  MovieSectionItem.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 25/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class SmallMovieCell: UICollectionViewCell {
  var movie: Movie? {
    didSet {
      titleLabel.text = movie?.title
      posterImageView.image = nil
      
      guard let posterPath = movie?.poster_path else { return }
      guard let url = URL(string: "https://image.tmdb.org/t/p/w300\(posterPath)") else { return }
      URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
          print(error)
          return
        }
        guard let data = data else { return }
        let image = UIImage(data: data)
        DispatchQueue.main.async {
          self.posterImageView.image = image
        }
        }.resume()
    }
  }
  
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
    label.textColor = .white
    return label
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(posterImageView)
    addSubview(titleLabel)
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": titleLabel]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": posterImageView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[poster][title(60)]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["poster": posterImageView, "title": titleLabel]))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
