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
      imageView.image = nil
      imageView.alpha = 0
      if let imagePath = imagePath {
        HttpAgent.request(url: "https://image.tmdb.org/t/p/w300\(imagePath)").responseJSON { (response) in
          guard let data = response.data else { return }
          self.imageView.image = UIImage(data: data)
          if response.isFromCache {
            self.imageView.alpha = 1
          } else {
            UIView.animate(withDuration: 0.5, animations: {
              self.imageView.alpha = 1
            })
          }
        }
      }
    }
  }
  
  let imageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.cornerRadius = 30
    imageView.layer.masksToBounds = true
    imageView.layer.borderColor = UIColor(white: 1, alpha: 0.5).cgColor
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
