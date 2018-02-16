//
//  SearchViewController.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 08/02/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  let cellId = "cellId"
  var searchTextFieldValue: String?
  var movieSearchResults: [Movie]?
  
  let searchInputContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    view.backgroundColor = Colors.secondary500
    return view
  }()
  
  let searchTextField: UITextField = {
    let textField = UITextField()
    textField.translatesAutoresizingMaskIntoConstraints = false
    textField.backgroundColor = Colors.primary500.withAlphaComponent(0.4)
    textField.layer.cornerRadius = 5
    textField.leftViewMode = .always
    textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: Spacing.padding400, height: 0))
    
    let clearButton = UIButton(type: .custom)
    clearButton.addTarget(self, action: #selector(clearTextField), for: .touchUpInside)
    clearButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    let clearButtonIcon = UIView()
    let buttonIconSize: CGFloat = 20
    clearButtonIcon.layer.cornerRadius = buttonIconSize / 2
    clearButtonIcon.backgroundColor = Colors.lightTextSecondary
    clearButtonIcon.isUserInteractionEnabled = false
    clearButtonIcon.frame = CGRect(x: 20 - buttonIconSize / 2, y: 20 - buttonIconSize / 2, width: buttonIconSize, height: buttonIconSize)
    clearButton.addSubview(clearButtonIcon)
    textField.rightView = clearButton
    textField.rightViewMode = .always
    textField.rightView?.isHidden = true
    
    textField.addTarget(self, action: #selector(searchForMovies(_:)), for: .editingChanged)
    textField.addTarget(nil, action: Selector(("firstResponderAction:")), for: .editingDidEndOnExit)
    textField.returnKeyType = .search
    textField.textColor = .white
    textField.attributedPlaceholder = NSAttributedString(string: "Search for movies", attributes: [NSAttributedStringKey.foregroundColor: Colors.lightTextSecondary])
    textField.keyboardAppearance = .dark
    textField.autocorrectionType = .no
    return textField
  }()
  
  let closeButton: UIButton = {
    let button = UIButton(type: .system)
    button.addTarget(self, action: #selector(closeSearch), for: .touchUpInside)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.setTitle("Close", for: .normal)
    button.setTitleColor(Colors.lightTextPrimary, for: .normal)
    button.contentEdgeInsets = UIEdgeInsets(top: 0, left: Spacing.padding400, bottom: 0, right: Spacing.padding400)
    return button
  }()
  
  let searchResultTableView: UITableView = {
    let tableView = UITableView()
    tableView.translatesAutoresizingMaskIntoConstraints = false
    tableView.backgroundColor = .clear
    tableView.keyboardDismissMode = .onDrag
    return tableView
  }()
  
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = Colors.lightTextDivider
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  @objc func closeSearch() {
    searchTextField.endEditing(true)
    dismiss(animated: true, completion: nil)
  }
  
  lazy var searchDebounced = Debouncer(delay: 0.4) {
    guard let searchTextFieldValue = self.searchTextFieldValue else { return }
    HttpAgent.request(url: "https://api.themoviedb.org/3/search/movie?api_key=\(apiKey)&query=\(searchTextFieldValue)").responseJSON(onReady: { (response) in
      guard let data = response.data else { return }
      do {
        let searchResponse = try JSONDecoder().decode(MovieDatabaseResponse.self, from: data)
        self.movieSearchResults = searchResponse.results
        self.searchResultTableView.reloadData()
      } catch {
        print(error)
      }
    })
  }
  
  @objc func searchForMovies(_ textField: UITextField) {
    searchTextFieldValue = textField.text
    if let length = searchTextFieldValue?.count, length > 0 {
      searchTextField.rightView?.isHidden = false
    } else {
      searchTextField.rightView?.isHidden = true
    }
    searchDebounced.call()
  }
  
  @objc func clearTextField() {
    searchTextField.text = ""
    searchTextField.becomeFirstResponder()
    searchTextField.rightView?.isHidden = true
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.setNavigationBarHidden(true, animated: true)
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    navigationController?.setNavigationBarHidden(false, animated: true)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
    navigationController?.navigationBar.shadowImage = UIImage()
    navigationController?.navigationBar.tintColor = Colors.lightTextPrimary
    
    searchTextField.becomeFirstResponder()
    
    searchResultTableView.dataSource = self
    searchResultTableView.delegate = self
    searchResultTableView.register(SearchResultCell.self, forCellReuseIdentifier: cellId)
    searchResultTableView.separatorStyle = .none
    
    view.addGradientBackground(fromColor: Colors.primary500, toColor: Colors.secondary500)
    view.addSubview(searchInputContainerView)
    view.addSubview(searchResultTableView)
    searchInputContainerView.addSubview(searchTextField)
    searchInputContainerView.addSubview(closeButton)
    searchInputContainerView.addSubview(separatorView)
    
    
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": searchInputContainerView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0(100)][v1]|", options: [], metrics: metrics, views: ["v0": searchInputContainerView, "v1": searchResultTableView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": separatorView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[v0(0.5)]|", options: [], metrics: metrics, views: ["v0": separatorView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": searchResultTableView]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-padding500-[v0][v1]|", options: [], metrics: metrics, views: ["v0": searchTextField, "v1": closeButton]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[v0]-padding500-|", options: [], metrics: metrics, views: ["v0": searchTextField]))
    view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[v0]-padding500-|", options: [], metrics: metrics, views: ["v0": closeButton]))
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movieSearchResults?.count ?? 0
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchResultCell
    cell.movie = movieSearchResults?[indexPath.row]
    cell.backgroundColor = .clear
    return cell
  }
  
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return 85
  }
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    if let movie = movieSearchResults?[indexPath.row] {
      let detailViewController = DetailViewController()
      detailViewController.movie = movie
      searchTextField.endEditing(true)
      navigationController?.pushViewController(detailViewController, animated: true)
    }
  }
  
}

class SearchResultCell: UITableViewCell {
  var movie: Movie? {
    didSet {
      titleLabel.text = movie?.title
      releaseDateLabel.text = movie?.release_date
      
      posterImageView.image = nil
      posterImageView.alpha = 0
      
      if let posterPath = movie?.poster_path {
        HttpAgent.request(url: "https://image.tmdb.org/t/p/w300\(posterPath)").responseJSON { (response) in
          guard let data = response.data else { return }
          self.posterImageView.image = UIImage(data: data)
          if response.isFromCache {
            self.posterImageView.alpha = 1
          } else {
            UIView.animate(withDuration: 0.5, animations: {
              self.posterImageView.alpha = 1
            })
          }
        }
      }
    }
  }
  
  let titleLabel: UILabel = {
    let label = UILabel()
    label.translatesAutoresizingMaskIntoConstraints = false
    label.textColor = Colors.lightTextPrimary
    label.font = UIFont.boldSystemFont(ofSize: 20)
    return label
  }()
  
  let releaseDateLabel: UILabel = {
    let label = UILabel()
    label.textColor = Colors.lightTextSecondary
    label.translatesAutoresizingMaskIntoConstraints = false
    label.font = UIFont.systemFont(ofSize: 14)
    return label
  }()
  
  let posterImageView: UIImageView = {
    let imageView = UIImageView()
    imageView.translatesAutoresizingMaskIntoConstraints = false
    imageView.contentMode = .scaleAspectFit
    return imageView
  }()
  
  let separatorView: UIView = {
    let view = UIView()
    view.backgroundColor = Colors.lightTextDivider
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  let textContainerView: UIView = {
    let view = UIView()
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()
  
  override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    addSubview(posterImageView)
    addSubview(textContainerView)
    textContainerView.addSubview(titleLabel)
    textContainerView.addSubview(releaseDateLabel)
    addSubview(separatorView)
    selectionStyle = .none
    
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-padding500-[v0(30)]-padding500-[v1]|", options: [], metrics: metrics, views:
      ["v0": posterImageView, "v1": textContainerView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0][v1(1)]|", options: [], metrics: metrics, views:
      ["v0": textContainerView, "v1": separatorView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[v0]|", options: [], metrics: metrics, views: ["v0": posterImageView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]-padding400-|", options: [], metrics: metrics, views: ["v0": titleLabel]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|[v0]|", options: [], metrics: metrics, views: ["v0": releaseDateLabel]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "|-70-[v0]|", options: [], metrics: metrics, views: ["v0": separatorView]))
    addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-padding500-[v0]-padding300-[v1]-padding500-|", options: [], metrics: metrics, views: ["v0": titleLabel, "v1": releaseDateLabel]))
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
