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
  private let maxHeaderHeight: CGFloat = 300
  private let minHeaderHeight: CGFloat = 64
  var previousScrollOffset: CGFloat = 0
  var headerHeightConstraint: NSLayoutConstraint!
  var movies: [Movie]?
  
  let headerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let mainImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()
  
  let tableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = Colors.secondary500
    tableView.tableFooterView = UIView()
    tableView.separatorStyle = .none
    return tableView
  }()
  
  var actor: Actor? {
    didSet {
      if let id = actor?.id {
        MovieApi.shared.personDetails(id: id).responseJSON(onReady: { (response) in
          guard let data = response.data else { return }
          print(data)
          do {
            let actorDetails = try JSONDecoder().decode(Actor.self, from: data)
            self.movies = actorDetails.movie_credits?.cast.filter({ (movie) -> Bool in
              guard let releaseDate = movie.release_date else { return false }
              return releaseDate.count > 0
            }).sorted(by: { (movie1, movie2) -> Bool in
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
        HttpAgent.request(url: "https://image.tmdb.org/t/p/w500\(profilePath)").responseJSON { (response) in
          guard let data = response.data else { return }
          self.mainImageView.image = UIImage(data: data)
        }
      }
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.backgroundColor = Colors.secondary500
    navigationController?.delegate = self
    tableView.register(SearchResultCell.self, forCellReuseIdentifier: cellId)
    
    view.addSubview(headerView)
    view.addSubview(tableView)
    headerView.addSubview(mainImageView)
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": headerView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": tableView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": mainImageView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": mainImageView]))
    headerHeightConstraint = headerView.heightAnchor.constraint(equalToConstant: maxHeaderHeight)
    if let headerHeightConstraint = headerHeightConstraint {
      NSLayoutConstraint.activate([
        headerView.topAnchor.constraint(equalTo: view.topAnchor),
        headerHeightConstraint,
        tableView.topAnchor.constraint(equalTo: headerView.bottomAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
      ])
    }
    
  }
  
  func navigationController(_ navigationController: UINavigationController, interactionControllerFor animationController: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
    return nil
  }
  
  override func viewDidLayoutSubviews() {
    tableView.delegate = self
    tableView.dataSource = self
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    self.headerHeightConstraint.constant = self.maxHeaderHeight
  }
  
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    let scrollDiff = scrollView.contentOffset.y - self.previousScrollOffset
    let absoluteTop: CGFloat = 0;
    let absoluteBottom: CGFloat = scrollView.contentSize.height - scrollView.frame.size.height;
    let isScrollingDown = scrollDiff > 0 && scrollView.contentOffset.y > absoluteTop
    let isScrollingUp = scrollDiff < 0 && scrollView.contentOffset.y < absoluteBottom
    
    var newHeight = self.headerHeightConstraint.constant
    if isScrollingDown {
      newHeight = max(self.minHeaderHeight, self.headerHeightConstraint.constant - abs(scrollDiff))
    } else if isScrollingUp && scrollView.contentOffset.y <= 0 {
      newHeight = min(self.maxHeaderHeight, self.headerHeightConstraint.constant + abs(scrollDiff))
    }
    
    if newHeight != self.headerHeightConstraint.constant {
      self.headerHeightConstraint.constant = newHeight
      self.setScrollPosition(position: self.previousScrollOffset)
    }
    
    self.previousScrollOffset = scrollView.contentOffset.y
  }
  
  func setScrollPosition(position: CGFloat) {
    self.tableView.contentOffset = CGPoint(x: self.tableView.contentOffset.x, y: position)
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchResultCell
    cell.movie = movies?[indexPath.row]
    cell.backgroundColor = .clear
    return cell
  }
}
