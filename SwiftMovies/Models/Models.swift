//
//  Models.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 27/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import Foundation

struct MovieDatabaseResponse: Decodable {
  let results: [Movie]
}

struct Movie: Decodable {
  let id: Int
  let title: String
  let poster_path: String?
  let backdrop_path: String?
  let release_date: String
  let overview: String
}
