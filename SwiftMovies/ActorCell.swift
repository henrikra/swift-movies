//
//  ActorCell.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 05/02/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class ActorCell: UICollectionViewCell {
  var imagePath: String? {
    didSet {
      if let imagePath = imagePath, let imageUrl = movieApi?.generateImageUrl(path: imagePath, size: .w92) {
        imageView.setImage(with: imageUrl)
      }
    }
  }
  var movieApi: MovieApi?
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 30
    imageView.layer.masksToBounds = true
    imageView.layer.borderColor = Colors.lightTextHint.cgColor
    imageView.layer.borderWidth = 1
    return imageView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(imageView)
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": imageView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": imageView]))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
