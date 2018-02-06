//
//  DetailViewController.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 27/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
  private let cellId = "cellId"
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cast?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ActorCell
    cell.imagePath = cast?[indexPath.item].profile_path
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 25
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 60, height: 60)
  }
  
  var cast: [Actor]?
  
  var movie: Movie? {
    didSet {
      titleLabel.text = movie?.title
      overviewLabel.text = movie?.overview
      
      if let backdropPath = movie?.backdrop_path {
        HttpAgent.request(url: "https://image.tmdb.org/t/p/w500\(backdropPath)").responseJSON { (response) in
          guard let data = response.data else { return }
          self.backdropImageView.image = UIImage(data: data)
        }
      }
      
      if let posterPath = movie?.poster_path {
        HttpAgent.request(url: "https://image.tmdb.org/t/p/w300\(posterPath)").responseJSON { (response) in
          guard let data = response.data else { return }
          self.posterImageView.image = UIImage(data: data)
        }
      }
      
      if let id = movie?.id {
        HttpAgent.request(url: "https://api.themoviedb.org/3/movie/\(id)?api_key=\(apiKey)").responseJSON(onReady: { (response) in
          guard let data = response.data else { return }
          do {
            let movie = try JSONDecoder().decode(Movie.self, from: data)
            self.genreNameLabel.text = movie.genres?.map({ $0.name }).joined(separator: ", ")
          } catch let jsonError {
            print(jsonError)
          }
        })
        
        HttpAgent.request(url: "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=\(apiKey)").responseJSON(onReady: { (response) in
          guard let data = response.data else { return }
          
          do {
            let credits = try JSONDecoder().decode(Credits.self, from: data)
            self.directorNameLabel.text = credits.crew.first(where: { $0.job == "Director" })?.name
            self.cast = credits.cast.filter({ $0.profile_path != nil })
            self.castCollectionView.reloadData()
          } catch let jsonError {
            print(jsonError)
          }
        })
      }
    }
  }
  
  let backdropImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  let backdropOverlayView: UIView = {
    let view = UIView()
    view.backgroundColor = UIColor(white: 0, alpha: 0.5)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let movieInfoView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.isUserInteractionEnabled = true
    imageView.contentMode = .scaleAspectFit
    imageView.layer.shadowColor = UIColor.black.cgColor
    imageView.layer.shadowOpacity = 0.2
    imageView.layer.shadowOffset = CGSize(width: 10, height: 10)
    imageView.layer.shadowRadius = 0
    imageView.tag = 99
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 22)
    label.textColor = .white
    label.textAlignment = .center
    return label
  }()
  
  let overviewLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 16)
    label.numberOfLines = 0
    return label
  }()
  
  let scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    scrollView.contentInset = UIEdgeInsets(top: -64, left: 0, bottom: 0, right: 0)
    return scrollView
  }()
  
  let directorLabel: UILabel = {
    let label = UILabel()
    label.text = "DIRECTOR"
    label.textColor = UIColor(white: 1, alpha: 0.7)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  
  let directorNameLabel: UILabel = {
    let label = UILabel()
    label.text = "..."
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 14)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let genreLabel: UILabel = {
    let label = UILabel()
    label.text = "GENRES"
    label.textColor = UIColor(white: 1, alpha: 0.7)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  
  let genreNameLabel: UILabel = {
    let label = UILabel()
    label.text = "..."
    label.textColor = .white
    label.font = UIFont.systemFont(ofSize: 14)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let creditContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let castLabel: UILabel = {
    let label = UILabel()
    label.text = "CAST"
    label.textColor = UIColor(white: 1, alpha: 0.7)
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  
  let castCollectionView: UICollectionView = {
    let layout = UICollectionViewFlowLayout()
    layout.scrollDirection = .horizontal
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    collectionView.backgroundColor = .clear
    collectionView.translatesAutoresizingMaskIntoConstraints = false
    collectionView.contentInset = UIEdgeInsets(top: 0, left: Spacing.padding500, bottom: 0, right: Spacing.padding500)
    return collectionView
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.secondary500
    
    view.addSubview(scrollView)
    
    castCollectionView.delegate = self
    castCollectionView.dataSource = self
    castCollectionView.register(ActorCell.self, forCellWithReuseIdentifier: cellId)

    let content = UIStackView(arrangedSubviews: [backdropImageView, movieInfoView])
    content.axis = .vertical
    content.translatesAutoresizingMaskIntoConstraints = false
    scrollView.addSubview(content)
    
    scrollView.alwaysBounceVertical = true
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": scrollView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": scrollView]))
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": content]))
    
    content.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    let heightConstraint = content.heightAnchor.constraint(equalTo: view.heightAnchor)
    heightConstraint.priority = UILayoutPriority(250)
    heightConstraint.isActive = true
    
    backdropImageView.addSubview(backdropOverlayView)
    movieInfoView.addSubview(titleLabel)
    movieInfoView.addSubview(overviewLabel)
    movieInfoView.addSubview(creditContainerView)
    creditContainerView.addSubview(directorLabel)
    creditContainerView.addSubview(directorNameLabel)
    creditContainerView.addSubview(genreLabel)
    creditContainerView.addSubview(genreNameLabel)
    movieInfoView.addSubview(castLabel)
    movieInfoView.addSubview(castCollectionView)
    view.addSubview(posterImageView)
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropOverlayView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": backdropOverlayView]))
    backdropImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true

    posterImageView.frame = CGRect(x: view.frame.width / 2 - 50, y: 100, width: 100, height: 150)

    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": titleLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": overviewLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": castLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": castCollectionView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[v0]-(padding500)-[v1]-(padding500)-[v2]-padding500-[v3][v4(88)]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": titleLabel, "v1": overviewLabel, "v2": creditContainerView, "v3": castLabel, "v4": castCollectionView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-padding500-[v0]-padding500-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": creditContainerView]))
    directorLabel.leadingAnchor.constraint(equalTo: creditContainerView.leadingAnchor).isActive = true
    directorLabel.widthAnchor.constraint(equalTo: creditContainerView.widthAnchor, multiplier: 0.4).isActive = true
    genreLabel.leadingAnchor.constraint(equalTo: directorLabel.trailingAnchor).isActive = true
    genreLabel.topAnchor.constraint(equalTo: creditContainerView.topAnchor).isActive = true
    genreLabel.trailingAnchor.constraint(equalTo: creditContainerView.trailingAnchor).isActive = true
    
    directorNameLabel.leadingAnchor.constraint(equalTo: creditContainerView.leadingAnchor).isActive = true
    directorNameLabel.trailingAnchor.constraint(equalTo: genreLabel.leadingAnchor, constant: -Spacing.padding300).isActive = true
    genreNameLabel.leadingAnchor.constraint(equalTo: genreLabel.leadingAnchor).isActive = true
    genreNameLabel.trailingAnchor.constraint(equalTo: genreLabel.trailingAnchor).isActive = true
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-(padding300)-[v1]|", options: [], metrics: metrics, views: ["v0": directorLabel, "v1": directorNameLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-(padding300)-[v1]|", options: [], metrics: metrics, views: ["v0": genreLabel, "v1": genreNameLabel]))
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    movieInfoView.addGradientBackground(fromColor: Colors.primary500, toColor: Colors.secondary500)
  }
}

