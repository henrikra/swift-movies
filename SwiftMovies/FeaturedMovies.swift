//
//  FeaturedMovies.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 22/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class FeaturedMovies: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  var movies: [Movie]?
  
  let moviesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = 0
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.backgroundColor = .clear
    collectionView.isPagingEnabled = true
    return collectionView
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    moviesCollectionView.dataSource = self
    moviesCollectionView.delegate = self
    moviesCollectionView.register(FeaturedMovie.self, forCellWithReuseIdentifier: "featureCellId")
    
    addSubview(moviesCollectionView)
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": moviesCollectionView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": moviesCollectionView]))
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "featureCellId", for: indexPath) as! FeaturedMovie
    cell.movie = movies?[indexPath.item]
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: frame.width, height: 200)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

class FeaturedMovie: UICollectionViewCell {
  var movie: Movie? {
    didSet {
      backdropImageView.image = nil
      
      guard let backdropPath = movie?.backdrop_path else { return }
      HttpAgent.request(url: "https://image.tmdb.org/t/p/w500\(backdropPath)").responseJSON { (response) in
        guard let data = response.data else { return }
        let image = UIImage(data: data)
        self.backdropImageView.image = image
      }
    }
  }
  
  let backdropImageView: UIImageView = {
    let backdrop = UIImageView()
    backdrop.translatesAutoresizingMaskIntoConstraints = false
    backdrop.layer.cornerRadius = 5
    backdrop.layer.masksToBounds = true
    return backdrop
  }()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    addSubview(backdropImageView)
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropImageView]))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
