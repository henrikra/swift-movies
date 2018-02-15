//
//  DetailViewController.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 27/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {
  private let cellId = "cellId"
  private let headerHeight: CGFloat = 200
  
  var cast: [Actor]?
  var trailerYoutubeId: String?
  
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
            if let runtime = movie.runtime {
              let hours = runtime / 60
              let minutes = runtime % 60
              if hours > 0 && minutes > 0 {
                self.runtimeLabel.text = String(describing: hours) + " h " + String(describing: minutes) + " min"
              } else if minutes > 0 {
                self.runtimeLabel.text = String(describing: minutes) + " min"
              } else {
                self.runtimeLabel.text = "0 min"
              }
            }
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
            self.castCollectionViewDelegate.cast = self.cast
            self.castCollectionView.reloadData()
          } catch let jsonError {
            print(jsonError)
          }
        })
        
        HttpAgent.request(url: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=\(apiKey)").responseJSON(onReady: { (response) in
          guard let data = response.data else { return }
          do {
            let videoResponse = try JSONDecoder().decode(VideosResponse.self, from: data)
            self.trailerYoutubeId = videoResponse.results.first?.key
          } catch {
            print(error)
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
    view.backgroundColor = UIColor(white: 0, alpha: 0.4)
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
    return imageView
  }()
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.boldSystemFont(ofSize: 22)
    label.textColor = .white
    label.textAlignment = .center
    label.numberOfLines = 2
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
  
  lazy var scrollView: UIScrollView = {
    let scrollView = UIScrollView()
    scrollView.translatesAutoresizingMaskIntoConstraints = false
    let navigationBarHeight = (navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.size.height
    scrollView.contentInset = UIEdgeInsets(top: -navigationBarHeight, left: 0, bottom: 0, right: 0)
    scrollView.scrollIndicatorInsets = UIEdgeInsets(top: -navigationBarHeight, left: 0, bottom: 0, right: 0)
    return scrollView
  }()
  
  let runtimeLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = UIColor.white.withAlphaComponent(0.7)
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "..."
    return label
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
  
  let dividerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = UIColor.white.withAlphaComponent(0.4)
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
    collectionView.showsHorizontalScrollIndicator = false
    return collectionView
  }()
  
  lazy var castCollectionViewDelegate = CastCollectionViewDelegate(cellId: cellId)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.primary500
    
    scrollView.delegate = self
    
    view.addSubview(scrollView)
    
    castCollectionView.delegate = castCollectionViewDelegate
    castCollectionView.dataSource = castCollectionViewDelegate
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
    movieInfoView.addSubview(runtimeLabel)
    movieInfoView.addSubview(overviewLabel)
    movieInfoView.addSubview(creditContainerView)
    movieInfoView.addSubview(dividerView)
    creditContainerView.addSubview(directorLabel)
    creditContainerView.addSubview(directorNameLabel)
    creditContainerView.addSubview(genreLabel)
    creditContainerView.addSubview(genreNameLabel)
    movieInfoView.addSubview(castLabel)
    movieInfoView.addSubview(castCollectionView)
    scrollView.addSubview(posterImageView)
    
    posterImageView.frame = CGRect(x: view.frame.width / 2 - 50, y: 100, width: 100, height: 150)
    posterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTrailerFromYoutube)))
    
    backdropOverlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight)
    backdropImageView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true

    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": titleLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": runtimeLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": overviewLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": castLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": castCollectionView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[v0]-padding400-[v1(25)]-padding400-[v2]-(padding500)-[v3]-padding500-[v4(0.5)]-padding500-[v5][v6(88)]|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": titleLabel, "v1": runtimeLabel, "v2": overviewLabel, "v3": creditContainerView, "v4": dividerView, "v5": castLabel, "v6": castCollectionView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-padding500-[v0]-padding500-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": creditContainerView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-padding500-[v0]-padding500-|", options: NSLayoutFormatOptions(), metrics: metrics, views: ["v0": dividerView]))
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
    movieInfoView.addGradientBackground(fromColor: Colors.secondary500, toColor: Colors.primary500, endPoint: CGPoint(x: 0.5, y: 0.7))
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let deltaY = fabs(scrollView.contentOffset.y)
    if scrollView.contentOffset.y <= 0 {
      let newHeight = headerHeight + deltaY
      
      var backdropImageViewNewFrame = backdropImageView.frame
      backdropImageViewNewFrame.size.height = newHeight
      backdropImageViewNewFrame.origin.y = -deltaY
      backdropImageView.frame = backdropImageViewNewFrame
      
      var backdropOverlayNewFrame = backdropOverlayView.frame
      backdropOverlayNewFrame.size.height = newHeight
      backdropOverlayView.frame = backdropOverlayNewFrame
    } else {
      var backdropImageViewNewFrame = backdropImageView.frame
      backdropImageViewNewFrame.origin.y = deltaY * 0.3
      backdropImageView.frame = backdropImageViewNewFrame
    }
  }
  
  @objc func openTrailerFromYoutube() {
    if let trailerYoutubeId = trailerYoutubeId {
      if let youtubeURL = URL(string: "youtube://\(trailerYoutubeId)"), UIApplication.shared.canOpenURL(youtubeURL) {
        UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
      } else if let youtubeURL = URL(string: "https://www.youtube.com/watch?v=\(trailerYoutubeId)") {
        UIApplication.shared.open(youtubeURL, options: [:], completionHandler: nil)
      }
    } else {
      let alertController = UIAlertController(title: "No trailer available", message: "This movie doesn't have trailer at the moment", preferredStyle: .alert)
      alertController.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
      present(alertController, animated: true, completion: nil)
    }
  }
}

class CastCollectionViewDelegate: NSObject, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
  let cellId: String
  var cast: [Actor]?
  
  init(cellId: String) {
    self.cellId = cellId
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: 60, height: 60)
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 25
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return cast?.count ?? 0
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ActorCell
    cell.imagePath = cast?[indexPath.item].profile_path
    return cell
  }
}

