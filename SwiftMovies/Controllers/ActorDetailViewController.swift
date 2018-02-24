//
//  ActorDetailViewController.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 20/02/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class ActorDetailViewController: UIViewController, UINavigationControllerDelegate, UITableViewDelegate, UITableViewDataSource {
  private let cellId = "cellId"
  private let headerReferenceHeight: CGFloat = 300
  private lazy var minHeaderHeight: CGFloat = {
    return (navigationController?.navigationBar.frame.height ?? 0) + UIApplication.shared.statusBarFrame.size.height
  }()
  
  var headerHeightConstraint: NSLayoutConstraint!
  var movies: [Movie]?
  
  let movieApi: MovieApi
  
  init(movieApi: MovieApi) {
    self.movieApi = movieApi
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  let headerView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    imageView.layer.masksToBounds = true
    return imageView
  }()
  
  let headerBorder: UIView = {
    let view = UIView()
    view.backgroundColor = Colors.lightTextDivider
    view.translatesAutoresizingMaskIntoConstraints = false
    view.alpha = 0
    return view
  }()
  
  let headerOverlay: UIView = {
    let view = UIView()
    return view
  }()
  
  let headerTitle: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = Colors.lightTextPrimary
    label.textAlignment = .center
    label.font = UIFont.boldSystemFont(ofSize: 22)
    return label
  }()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .clear
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    tableView.showsVerticalScrollIndicator = false
    return tableView
  }()
  
  var actor: Actor? {
    didSet {
      headerTitle.text = actor?.name
      
      if let id = actor?.id {
        movieApi.personDetails(id: id).responseJSON(onReady: { (response) in
          guard let data = response.data else { return }
          do {
            let actorDetails = try JSONDecoder().decode(Actor.self, from: data)
            self.movies = actorDetails.movie_credits?.cast.filter({ (movie) -> Bool in
              guard let releaseDate = movie.release_date else { return false }
              return releaseDate.count > 0
            }).filter({ $0.poster_path != nil }).sorted(by: { (movie1, movie2) -> Bool in
              guard let releaseDate1 = movie1.release_date, let releaseDate2 = movie2.release_date else { return false }
              return releaseDate1 > releaseDate2
            })
            self.tableView.reloadData()
          } catch {
            print(error)
          }
        })
      }
      if let profilePath = actor?.profile_path {
        headerView.setImage(with: movieApi.generateImageUrl(path: profilePath, size: .w500))
      }
    }
  }
  
  var headerGradientLayer: CAGradientLayer?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    _ = view.addGradientBackground(fromColor: Colors.primary500, toColor: Colors.secondary500, startPoint: CGPoint(x: 1, y: 0.5))
    navigationController?.delegate = self
    tableView.register(SearchResultCell.self, forCellReuseIdentifier: cellId)
    tableView.delegate = self
    tableView.dataSource = self
    tableView.contentInset = UIEdgeInsets(top: headerReferenceHeight - 64, left: 0, bottom: 0, right: 0)
    
    view.addSubview(headerView)
    headerView.addSubview(headerOverlay)
    headerGradientLayer = headerOverlay.addGradientBackground(fromColor: .clear, toColor: Colors.primary500, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
    headerView.addSubview(headerTitle)
    headerView.addSubview(headerBorder)
    view.addSubview(tableView)
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": headerView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": headerTitle]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": headerBorder]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0]-padding400-[v1(1)]|", options: [], metrics: metrics, views: ["v0": headerTitle, "v1": headerBorder]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": tableView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": tableView]))
    headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: headerReferenceHeight)
    if let headerHeightConstraint = headerHeightConstraint {
      NSLayoutConstraint.activate([
        headerView.topAnchor.constraint(equalTo: view.topAnchor),
        headerHeightConstraint,
      ])
    }
  }
  
  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    if headerGradientLayer?.frame.width == 0 {
      headerGradientLayer?.frame = CGRect(x: headerView.frame.minX, y: headerView.frame.maxY - 150, width: headerView.frame.width, height: 150)
    } else {
      CATransaction.begin()
      CATransaction.setDisableActions(true)
      headerGradientLayer?.frame = CGRect(x: headerView.frame.minX, y: headerView.frame.maxY - 150, width: headerView.frame.width, height: 150)
      CATransaction.commit()
    }
  }
  
  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return nil
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let newHeaderHeight = headerReferenceHeight - (scrollView.contentOffset.y + headerReferenceHeight)
    headerHeightConstraint.constant = max(minHeaderHeight, newHeaderHeight)
    if newHeaderHeight <= minHeaderHeight {
      view.bringSubview(toFront: headerView)
      UIView.animate(withDuration: 0.2, animations: {
        self.headerBorder.alpha = 1
      })
    } else {
      view.bringSubview(toFront: tableView)
      UIView.animate(withDuration: 0.2, animations: {
        self.headerBorder.alpha = 0
      })
    }
  }
  
  func setScrollPosition(position: CGFloat) {
    self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let detailViewController = MovieDetailViewController(movieApi: MovieApi())
    detailViewController.movie = movies?[indexPath.row]
    navigationController?.pushViewController(detailViewController, animated: true)
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as? SearchResultCell else { return UITableViewCell() }
    cell.movieApi = MovieApi()
    cell.movie = movies?[indexPath.row]
    cell.backgroundColor = .clear
    return cell
  }
}
