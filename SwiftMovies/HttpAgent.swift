//
//  HttpAgent.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 21/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import Foundation

struct Response {
  let data: Data?
  let response: URLResponse
  let error: Error?
}

struct Request {
  let url: String
  func responseJSON(onReady: @escaping (Response) -> ()) {
    guard let uri = URL(string: url) else { return }
    URLSession.shared.dataTask(with: uri) { (data, response, error) in
      guard let response = response else { return }
      DispatchQueue.main.async {
        onReady(Response(data: data, response: response, error: error))
      }
    }.resume()
  }
}

struct HttpAgent {
  static func request(url: String) -> Request {
    return Request(url: url)
  }
}

