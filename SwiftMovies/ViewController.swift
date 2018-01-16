//
//  ViewController.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 16/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
  var movies: [Movie]?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cellId")
    tableView.tableFooterView = UIView()
    
    navigationItem.title = "Movies"
    setupMovies()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 80
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
    cell.textLabel?.text = movies?[indexPath.row].title
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies?.count ?? 0
  }
  
  func setupMovies() {
    let action = Genre(name: "Action")
    let comedy = Genre(name: "Comedy")
    let interstellar = Movie(title: "Interstellar", genres: [action])
    let kummeli = Movie(title: "Kummeli", genres: [comedy])
    self.movies = [kummeli, interstellar]
  }
}
