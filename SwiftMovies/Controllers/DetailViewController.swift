//
//  DetailViewController.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 27/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class PlayIconView : UIView {
  override init(frame: CGRect) {
    super.init(frame: frame)
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func draw(_ rect: CGRect) {
    
    guard let context = UIGraphicsGetCurrentContext() else { return }
    
    context.beginPath()
    context.move(to: CGPoint(x: rect.minX, y: rect.minY))
    context.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
    context.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY / 2))
    context.closePath()
    
    context.setFillColor(red: 1, green: 1, blue: 1, alpha: 1)
    context.fillPath()
  }
}

class DetailViewController: UIViewController, UICollectionViewDelegateFlowLayout {
  private let cellId = "cellId"
  private let headerHeight: CGFloat = 200
  var movieApi: MovieApi!
  
  init(movieApi: MovieApi) {
    super.init(nibName: nil, bundle: nil)
    self.movieApi = movieApi
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  var cast: [Actor]?
  var trailerYoutubeId: String?
  
  var movie: Movie? {
    didSet {
      titleLabel.text = movie?.title
      overviewLabel.text = movie?.overview
      
      if let backdropPath = movie?.backdrop_path {
        backdropImageView.setImage(with: "https://image.tmdb.org/t/p/w500\(backdropPath)")
      }
      
      if let posterPath = movie?.poster_path {
        posterImageView.setImage(with: "https://image.tmdb.org/t/p/w300\(posterPath)", animationEnabled: false)
      }
      
      if let id = movie?.id {
        movieApi.details(id: id).responseJSON(onReady: { (response) in
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
            self.trailerYoutubeId = movie.videos?.results.first?.key
            self.directorNameLabel.text = movie.credits?.crew.first(where: { $0.job == "Director" })?.name
            self.cast = movie.credits?.cast.filter({ $0.profile_path != nil })
            self.castCollectionViewDelegate.cast = self.cast
            self.castCollectionView.reloadData()
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
    view.backgroundColor = Colors.primary500
    return view
  }()
  
  let playIcon: PlayIconView = {
    let playIcon = PlayIconView()
    playIcon.layer.shadowColor = UIColor.black.cgColor
    playIcon.layer.shadowOffset = CGSize(width: 0, height: 0)
    playIcon.layer.shadowRadius = 5
    playIcon.layer.shadowOpacity = 0.7
    playIcon.backgroundColor = .clear
    return playIcon
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
    label.textColor = Colors.lightTextPrimary
    label.textAlignment = .center
    label.numberOfLines = 2
    return label
  }()
  
  let overviewLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = Colors.lightTextPrimary
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
    label.textColor = Colors.lightTextSecondary
    label.textAlignment = .center
    label.font = UIFont.systemFont(ofSize: 14)
    label.text = "..."
    return label
  }()
  
  let directorLabel: UILabel = {
    let label = UILabel()
    label.text = "DIRECTOR"
    label.textColor = Colors.lightTextSecondary
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  
  let directorNameLabel: UILabel = {
    let label = UILabel()
    label.text = "..."
    label.textColor = Colors.lightTextPrimary
    label.font = UIFont.systemFont(ofSize: 14)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()
  
  let genreLabel: UILabel = {
    let label = UILabel()
    label.text = "GENRES"
    label.textColor = Colors.lightTextSecondary
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 12)
    return label
  }()
  
  let genreNameLabel: UILabel = {
    let label = UILabel()
    label.text = "..."
    label.textColor = Colors.lightTextPrimary
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
    view.backgroundColor = Colors.lightTextDivider
    return view
  }()
  
  let castLabel: UILabel = {
    let label = UILabel()
    label.text = "CAST"
    label.textColor = Colors.lightTextSecondary
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
  
  func openActor(actor: Actor) {
    let actorDetailViewController = ActorDetailViewController(movieApi: MovieApi())
    actorDetailViewController.actor = actor
    navigationController?.pushViewController(actorDetailViewController, animated: true)
  }
  
  lazy var castCollectionViewDelegate = CastCollectionViewDelegate(cellId: cellId, onActorPress: openActor)
  
  var movieInfoViewGradientLayer: CAGradientLayer?
  
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
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": scrollView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": scrollView]))
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": content]))
    
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
    posterImageView.addSubview(playIcon)
    
    posterImageView.frame = CGRect(x: view.frame.width / 2 - 50, y: 100, width: 100, height: 150)
    let playIconSize: CGFloat = 29
    playIcon.frame = CGRect(x: posterImageView.frame.width / 2 - playIconSize / 2, y: posterImageView.frame.height / 2 - playIconSize / 2, width: playIconSize, height: playIconSize)
    posterImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openTrailerFromYoutube)))
    
    backdropOverlayView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: headerHeight)
    backdropImageView.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true

    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: [], metrics: metrics, views: ["v0": titleLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: [], metrics: metrics, views: ["v0": runtimeLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: [], metrics: metrics, views: ["v0": overviewLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-(padding500)-[v0]-(padding500)-|", options: [], metrics: metrics, views: ["v0": castLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": castCollectionView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-75-[v0]-padding400-[v1(25)]-padding400-[v2]-(padding500)-[v3]-padding500-[v4(1)]-padding500-[v5][v6(88)]|", options: [], metrics: metrics, views: ["v0": titleLabel, "v1": runtimeLabel, "v2": overviewLabel, "v3": creditContainerView, "v4": dividerView, "v5": castLabel, "v6": castCollectionView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-padding500-[v0]-padding500-|", options: [], metrics: metrics, views: ["v0": creditContainerView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-padding500-[v0]-padding500-|", options: [], metrics: metrics, views: ["v0": dividerView]))
    directorLabel.leadingAnchor.constraint(equalTo: creditContainerView.leadingAnchor).isActive = true
    directorLabel.widthAnchor.constraint(equalTo: creditContainerView.widthAnchor, multiplier: 0.4).isActive = true
    
    NSLayoutConstraint.activate([
      genreLabel.leadingAnchor.constraint(equalTo: directorLabel.trailingAnchor),
      genreLabel.topAnchor.constraint(equalTo: creditContainerView.topAnchor),
      genreLabel.trailingAnchor.constraint(equalTo: creditContainerView.trailingAnchor),
      directorNameLabel.leadingAnchor.constraint(equalTo: creditContainerView.leadingAnchor),
      directorNameLabel.trailingAnchor.constraint(equalTo: genreLabel.leadingAnchor, constant: -Spacing.padding300),
      genreNameLabel.leadingAnchor.constraint(equalTo: genreLabel.leadingAnchor),
      genreNameLabel.trailingAnchor.constraint(equalTo: genreLabel.trailingAnchor)
    ])
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-(padding300)-[v1]|", options: [], metrics: metrics, views: ["v0": directorLabel, "v1": directorNameLabel]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]-(padding300)-[v1]|", options: [], metrics: metrics, views: ["v0": genreLabel, "v1": genreNameLabel]))
    movieInfoViewGradientLayer = movieInfoView.addGradientBackground(fromColor: Colors.secondary500, toColor: Colors.primary500, endPoint: CGPoint(x: 0.5, y: 0.7))
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    movieInfoViewGradientLayer?.frame = movieInfoView.bounds
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
  let onActorPress: (Actor) -> Void
  
  init(cellId: String, onActorPress: @escaping (Actor) -> Void) {
    self.cellId = cellId
    self.onActorPress = onActorPress
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
  
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    if let actor = cast?[indexPath.item] {
      onActorPress(actor)
    }
    
  }
}

