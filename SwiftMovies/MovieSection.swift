//
//  CategoryCell.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 17/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

let cellWidth: CGFloat = 100.0
let minimumLineSpacing: CGFloat = 40.0

class MovieSection: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  var movies: [Movie]?
  var onPress: ((Movie) -> Void)?
  
  let moviesCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    layout.minimumLineSpacing = minimumLineSpacing
    layout.sectionInset = UIEdgeInsets(top: 0, left: Spacing.padding500, bottom: 0, right: Spacing.padding500)
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
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MovieSectionCell
    cell.movie = movies?[indexPath.item]
    return cell
  }
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    moviesCollectionView.dataSource = self
    moviesCollectionView.delegate = self
    moviesCollectionView.register(MovieSectionCell.self, forCellWithReuseIdentifier: "cellId")
    
    addSubview(moviesCollectionView)
    addSubview(categoryTitleLabel)
    addSubview(dividerView)
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": categoryTitleLabel]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: nil, views: ["v0": moviesCollectionView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": dividerView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[title(25)]-15-[movieCollection][divider(1)]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["title": categoryTitleLabel, "movieCollection": moviesCollectionView, "divider": dividerView]))
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: cellWidth, height: frame.height - 41)
  }
  
  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let totalCellWidth: CGFloat = cellWidth + minimumLineSpacing
    var nextItem = round(targetContentOffset.pointee.x / totalCellWidth)
    if scrollView.contentOffset.x > targetContentOffset.pointee.x {
      nextItem += 1
    }
    targetContentOffset.pointee = CGPoint(x: nextItem * totalCellWidth, y: targetContentOffset.pointee.y)
  }
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let movie = movies?[indexPath.item] {
      onPress?(movie)
    }
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
