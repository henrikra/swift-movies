//
//  Models.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 16/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class Movie {
  let title: String
  let genres: [Genre]
  let image: UIImage
  
  init(title: String, genres: [Genre], image: UIImage) {
    self.title = title
    self.genres = genres
    self.image = image
  }
}

class Genre {
  let name: String
  
  init(name: String) {
    self.name = name
  }
}
