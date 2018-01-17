//
//  CategoryCell.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 17/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 10
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SmallMovieCell
    return cell
  }
  
  let moviesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 40.0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .clear
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    moviesCollectionView.dataSource = self
    moviesCollectionView.delegate = self
    moviesCollectionView.register(SmallMovieCell.self, forCellWithReuseIdentifier: "cellId")
    moviesCollectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
    
    addSubview(moviesCollectionView)
    moviesCollectionView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
    moviesCollectionView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
    moviesCollectionView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
    moviesCollectionView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: frame.height)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class SmallMovieCell: UICollectionViewCell {
  let posterImageView: UIImageView = {
    let imageView = UIImageView(image: #imageLiteral(resourceName: "mad_max"))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.text = "Mad Max Adventures"
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
    
    posterImageView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height - 30)
    titleLabel.frame = CGRect(x: 0, y: frame.height - 30, width: frame.width, height: 30)
    
//    titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
//    titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
//    titleLabel.heightAnchor.constraint(equalToConstant: CGFloat(50))
//
//
//    posterImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 0).isActive = true
//    posterImageView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: 0).isActive = true
//    posterImageView.topAnchor.constraint(equalTo: self.topAnchor, constant: 0).isActive = true
//    posterImageView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -40).isActive = true
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
