//
//  FeaturedMovies.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 17/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class MovieSections: UICollectionView, UICollectionViewDelegateFlowLayout, UICollectionViewDelegate, UICollectionViewDataSource {
  var upcomingMovies: [Movie]?
  var topRatedMovies: [Movie]?
  var popularMovies: [Movie]?
  var onMoviePress: ((Movie, CGRect, UIImageView) -> Void)?
  var genres: [Genre]?
  var hideLoader: (() -> Void)?
  var isUpcomingMoviesLoaded = false
  var isTopRatedMoviesLoaded = false
  var isPopularMoviesLoaded = false
  var movieApi: MovieApi!
  
  init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout, movieApi: MovieApi) {
    super.init(frame: frame, collectionViewLayout: layout)
    self.movieApi = movieApi
    delegate = self
    dataSource = self
    backgroundColor = .clear
    contentInset = UIEdgeInsets(top: Spacing.padding500, left: 0, bottom: Spacing.padding500, right: 0)
    scrollIndicatorInsets = UIEdgeInsets(top: -Spacing.padding500, left: 0, bottom: 0, right: 0)
    register(MovieSection.self, forCellWithReuseIdentifier: "cellId")
    register(FeaturedMovies.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "featuredMoviesId")
    
    fetchMovieGenres()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func fetchMovieGenres() {
    movieApi.movieGenres().responseJSON { (response) in
      guard let data = response.data else { return }
      do {
        self.genres = try JSONDecoder().decode(MovieGenresResponse.self, from: data).genres
        self.fetchUpcomingMovies()
        self.fetchTopRatedMovies()
        self.fetchPopularMovies()
      } catch {
        print(error)
      }
    }
  }
  
  func fetchUpcomingMovies() {
    movieApi.upcoming().responseJSON { response in
      do {
        guard let data = response.data else { return }
        let upcomingMoviesResponse = try JSONDecoder().decode(MovieDatabaseResponse.self, from: data)
        self.upcomingMovies = upcomingMoviesResponse.results?.filter {$0.poster_path != nil}
        self.reloadData()
        self.isUpcomingMoviesLoaded = true
        self.hideLoaderIfAllLoaded()
      } catch let jsonError {
        print(jsonError)
      }
    }
  }
  
  func fetchTopRatedMovies() {
    movieApi.topRated().responseJSON { (response) in
      guard let data = response.data else { return }
      do {
        let topRatedMoviesResponse = try JSONDecoder().decode(MovieDatabaseResponse.self, from: data)
        self.topRatedMovies = topRatedMoviesResponse.results
        self.reloadData()
        self.isTopRatedMoviesLoaded = true
        self.hideLoaderIfAllLoaded()
      } catch let jsonError {
        print(jsonError)
      }
    }
  }
  
  func fetchPopularMovies() {
    movieApi.popular().responseJSON { (response) in
      guard let data = response.data else { return }
      do {
        let popularMoviesResponse = try JSONDecoder().decode(MovieDatabaseResponse.self, from: data)
        self.popularMovies = popularMoviesResponse.results
        self.reloadData()
        self.isPopularMoviesLoaded = true
        self.hideLoaderIfAllLoaded()
      } catch let jsonError {
        print(jsonError)
      }
    }
  }
  
  func hideLoaderIfAllLoaded() {
    if isPopularMoviesLoaded && isTopRatedMoviesLoaded && isUpcomingMoviesLoaded {
      hideLoader?()
    }
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    return CGSize(width: frame.width, height: 260)
  }
  
  func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
    let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "featuredMoviesId", for: indexPath) as! FeaturedMovies
    let featuredMovieController = FeaturedMovieController(movieApi: MovieApi())
    featuredMovieController.onPress = onMoviePress
    featuredMovieController.genres = genres
    featuredMovieController.movie = self.upcomingMovies?.first
    if let movies = self.upcomingMovies {
      header.featuredMoviesController.movies = Array(movies[..<5])
    }
    header.featuredMoviesController.setViewControllers([featuredMovieController], direction: .forward, animated: false, completion: nil)
    return header
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 20.0
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let cell = dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as? MovieSection else { return UICollectionViewCell() }
    if indexPath.item == 0 {
      cell.categoryTitleLabel.text = "Popular"
      cell.movies = popularMovies
    } else if indexPath.item == 1 {
      cell.categoryTitleLabel.text = "Top rated"
      cell.movies = topRatedMovies
    }
    cell.onPress = onMoviePress
    cell.moviesCollectionView.reloadData()
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: frame.width, height: 250)
  }
}
