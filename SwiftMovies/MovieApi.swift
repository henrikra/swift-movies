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
  
  static let shared = MovieApi()
  
  func upcoming() -> Request {
    
    return HttpAgent.request(url: "\(baseUrl)movie/upcoming?api_key=\(apiKey)")
  }
  
  func topRated() -> Request {
    return HttpAgent.request(url: "\(baseUrl)movie/top_rated?api_key=\(apiKey)")
  }
  
  func popular() -> Request {
    return HttpAgent.request(url: "\(baseUrl)movie/popular?api_key=\(apiKey)")
  }
  
  func searchMovies(query: String) -> Request {
    return HttpAgent.request(url: "\(baseUrl)search/movie?api_key=\(apiKey)&query=\(query)")
  }
  
  func details(id: Int) -> Request {
    return HttpAgent.request(url: "\(baseUrl)movie/\(id)?api_key=\(apiKey)&append_to_response=videos,credits")
  }
  
  func movieGenres() -> Request {
    return HttpAgent.request(url: "\(baseUrl)genre/movie/list?api_key=\(apiKey)")
  }
  
  func personDetails(id: Int) -> Request {
    return HttpAgent.request(url: "\(baseUrl)person/\(id)?api_key=\(apiKey)&append_to_response=movie_credits")
  }
}
