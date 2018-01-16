//
//  MovieCell.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 16/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class MovieCell: UITableViewCell {
  let backdropImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.backgroundColor = .red
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.image = #imageLiteral(resourceName: "blade_runner_backdrop")
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "terve"
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(backdropImageView)
    addSubview(titleLabel)
    
    backdropImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
    backdropImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    backdropImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
    backdropImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
    
    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 30).isActive = true
    titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -30).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
