//
//  Models.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 27/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import Foundation

struct MovieDatabaseResponse: Decodable {
  let results: [Movie]?
}

struct Movie: Decodable {
  let id: Int
  let title: String
  let poster_path: String?
  let backdrop_path: String?
  let release_date: String
  let overview: String
  let genres: [Genre]?
  let genre_ids: [Int]?
  let runtime: Int?
  let videos: VideosResponse?
  let credits: Credits?
}

struct Genre: Decodable {
  let id: Int
  let name: String
}

struct Credits: Decodable {
  let cast: [Actor]
  let crew: [CrewMember]
}

struct Actor: Decodable {
  let profile_path: String?
}

struct CrewMember: Decodable {
  let job: String
  let name: String
}

struct VideosResponse: Decodable {
  let results: [MovieVideo]
}

struct MovieVideo: Decodable {
  let key: String
}

struct MovieGenresResponse: Decodable {
  let genres: [Genre]
}

struct Keys: Decodable {
  let ApiKey: String
}
