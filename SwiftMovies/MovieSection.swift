//
//  CategoryCell.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 17/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class MovieSection: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  var movies: [Movie]?
  
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
  
  let categoryTitleLabel: UILabel = {
    let label = UILabel()
    label.text = "Latest"
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
    return label
  }()
  
  let dividerView: UIView = {
    let divider = UIView()
    divider.backgroundColor = UIColor.white.withAlphaComponent(0.2)
    divider.translatesAutoresizingMaskIntoConstraints = false
    return divider
  }()

  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! SmallMovieCell
    cell.movie = movies?[indexPath.item]
    return cell
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    moviesCollectionView.dataSource = self
    moviesCollectionView.delegate = self
    moviesCollectionView.register(SmallMovieCell.self, forCellWithReuseIdentifier: "cellId")
    moviesCollectionView.contentInset = UIEdgeInsets(top: 0, left: Spacing.padding500, bottom: 0, right: Spacing.padding500)
    
    addSubview(moviesCollectionView)
    addSubview(categoryTitleLabel)
    addSubview(dividerView)
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": categoryTitleLabel]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": moviesCollectionView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": dividerView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[title(25)]-15-[movieCollection][divider(1)]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["title": categoryTitleLabel, "movieCollection": moviesCollectionView, "divider": dividerView]))
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 100, height: frame.height - 41)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

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
