//
//  FeaturedMovies.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 17/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

struct UpcomingMoviesResponse: Decodable {
  let results: [MoviePoster]
}

struct MoviePoster: Decodable {
  let title: String
  let poster_path: String?
}

class MovieSections: UICollectionViewController, UICollectionViewDelegateFlowLayout {
  var upcomingMovies: [MoviePoster]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    collectionView?.backgroundColor = .clear
    collectionView?.contentInset = UIEdgeInsets(top: Spacing.padding500, left: 0, bottom: Spacing.padding500, right: 0)
    collectionView?.register(MovieSection.self, forCellWithReuseIdentifier: "cellId")
    
    fetchUpcomingMovies()
  }
  
  func fetchUpcomingMovies() {
    guard let url = URL(string: "https://api.themoviedb.org/3/movie/upcoming?api_key=\(apiKey)") else { return }
    URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        print("Error from api", error)
        return
      }
      
      guard let data = data else { return }
      do {
        let upcomingMoviesResponse = try JSONDecoder().decode(UpcomingMoviesResponse.self, from: data)
        self.upcomingMovies = upcomingMoviesResponse.results.filter {$0.poster_path != nil}
        DispatchQueue.main.async {
          self.collectionView?.reloadData()
        }
      } catch let jsonError {
        print(jsonError)
      }
    }.resume()
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return 20.0
  }
  
  override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 3
  }
  
  override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! MovieSection
    if indexPath.item == 0 {
      cell.movies = upcomingMovies
      cell.moviesCollectionView.reloadData()      
    }
    return cell
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: view.frame.width, height: 250)
  }
}
