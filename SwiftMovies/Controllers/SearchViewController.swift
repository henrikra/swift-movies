//
//  SearchViewController.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 08/02/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
  var searchTextFieldValue: String?
  var movieSearchResults: [Movie]?
  
  let searchInputContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let searchTextField: UITextField = {
    let textField = UITextField()
    textField.placeholder = "Search for movies"
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.backgroundColor = .white
    textField.layer.cornerRadius = 5
    textField.leftViewMode = .always
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.padding400, height: 0))
    textField.addTarget(self, action: #selector(searchForMovies(_:)), for: .editingChanged)
    return textField
  }()
  
  let closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(closeSearch), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Close", for: .normal)
    button.setTitleColor(.white, for: .normal)
    return button
  }()
  
  @objc func closeSearch() {
    searchTextField.endEditing(true)
    dismiss(animated: true, completion: nil)
  }
  
  lazy var searchDebounced = Debouncer(delay: 0.30) {
    guard let searchTextFieldValue = self.searchTextFieldValue else { return }
    HttpAgent.request(url: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchTextFieldValue)").responseJSON(onReady: { (response) in
      guard let data = response.data else { return }
      do {
        let searchResponse = try JSONDecoder().decode(MovieDatabaseResponse.self, from: data)
        self.movieSearchResults = searchResponse.results
        print(searchResponse)
      } catch {
        print(error)
      }
    })
  }
  
  @objc func searchForMovies(_ textField: UITextField) {
    searchTextFieldValue = textField.text
    searchDebounced.call()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    view.addGradientBackground(fromColor: Colors.primary500, toColor: Colors.secondary500)
    view.addSubview(searchInputContainerView)
    searchInputContainerView.addSubview(searchTextField)
    searchInputContainerView.addSubview(closeButton)
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": searchInputContainerView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[v0(50)]", options: [], metrics: metrics, views: ["v0": searchInputContainerView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-padding500-[v0]-padding500-[v1]-padding500-|", options: [], metrics: metrics, views: ["v0": searchTextField, "v1": closeButton]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": searchTextField]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": closeButton]))
  }
}
