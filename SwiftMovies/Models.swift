//
//  Models.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 16/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import Foundation

class Movie {
  let title: String
  let genres: [Genre]
  
  init(title: String, genres: [Genre]) {
    self.title = title
    self.genres = genres
  }
}

class Genre {
  let name: String
  
  init(name: String) {
    self.name = name
  }
}
