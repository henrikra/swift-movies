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
    
    tableView.register(MovieCell.self, forCellReuseIdentifier: "cellId")
    tableView.tableFooterView = UIView()
    
    navigationItem.title = "Movies"
    setupMovies()
  }
  
  override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 150
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath)
//    let movie = movies?[indexPath.row]
//    cell.textLabel?.text = movie?.title
//    cell.imageView?.image = movie?.image
    return cell
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies?.count ?? 0
  }
  
  func setupMovies() {
    let action = Genre(name: "Action")
    let comedy = Genre(name: "Comedy")
    let interstellar = Movie(title: "Martian", genres: [action], image: #imageLiteral(resourceName: "martian_backdrop"))
    let kummeli = Movie(title: "Blade Runner", genres: [comedy], image: #imageLiteral(resourceName: "blade_runner_backdrop"))
    let ghostInTheShell = Movie(title: "Ghost in the shell", genres: [action], image: #imageLiteral(resourceName: "ghost_in_the_shell_backdrop"))
    self.movies = [kummeli, interstellar, ghostInTheShell]
  }
}
