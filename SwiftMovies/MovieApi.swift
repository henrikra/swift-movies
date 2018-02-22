//
//  MovieApi.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 17/02/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import Foundation

class MovieApi {
  private let baseUrl = "https://api.themoviedb.org/3/"
  private let apiKey: String = {
    if let apiKey = Bundle.main.object(forInfoDictionaryKey: "API_KEY") as? String {
      if (apiKey.count == 0) {
        fatalError("Missing api key")
      }
      return apiKey
    } else {
      fatalError("Missing api key")
    }
  }()
  
  private func generateMovieUrl(path: String, queryParams: [String: String] = [:]) -> String {
    let baseQueryParams: [String: String] = ["api_key": apiKey]
    let allQueryParams = baseQueryParams
      .merging(queryParams, uniquingKeysWith: { $1 })
      .map { "\($0)=\($1)" }
      .joined(separator: "&")
    return "\(baseUrl)\(path)?\(allQueryParams)"
  }
  
  func upcoming() -> Request {
    return HttpAgent.request(url: generateMovieUrl(path: "movie/upcoming"))
  }
  
  func topRated() -> Request {
    return HttpAgent.request(url: generateMovieUrl(path: "movie/top_rated"))
  }
  
  func popular() -> Request {
    return HttpAgent.request(url: generateMovieUrl(path: "movie/popular"))
  }
  
  func searchMovies(query: String) -> Request {
    return HttpAgent.request(url: generateMovieUrl(path: "search/movie", queryParams: ["query": query]))
  }
  
  func details(id: Int) -> Request {
    return HttpAgent.request(url: generateMovieUrl(path: "movie/\(id)", queryParams: ["append_to_response": "videos,credits"]))
  }
  
  func movieGenres() -> Request {
    return HttpAgent.request(url: generateMovieUrl(path: "genre/movie/list"))
  }
  
  func personDetails(id: Int) -> Request {
    return HttpAgent.request(url: generateMovieUrl(path: "person/\(id)", queryParams: ["append_to_response": "movie_credits"]))
  }
}
