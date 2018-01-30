//
//  Constants.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 24/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

enum Spacing {
  static let padding400: CGFloat = 14.0
  static let padding500: CGFloat = 20.0
}

let metrics = ["padding500": Spacing.padding500, "padding400": Spacing.padding400]

enum Colors {
  static let primary500 = UIColor(red: 75.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1.0)
  static let secondary500 = UIColor(red: 14.0/255.0, green: 16.0/255.0, blue: 27.0/255.0, alpha: 1.0)
}
