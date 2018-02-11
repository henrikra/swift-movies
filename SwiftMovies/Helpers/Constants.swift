//
//  Constants.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 24/01/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import UIKit

enum Spacing {
  static let padding300: CGFloat = 10.0
  static let padding400: CGFloat = 14.0
  static let padding500: CGFloat = 20.0
}

let metrics = ["padding500": Spacing.padding500, "padding400": Spacing.padding400, "padding300": Spacing.padding300]

enum Colors {
  static let primary500 = UIColor(red: 75.0/255.0, green: 35.0/255.0, blue: 42.0/255.0, alpha: 1.0)
  static let secondary500 = UIColor(red: 14.0/255.0, green: 16.0/255.0, blue: 27.0/255.0, alpha: 1.0)
  static let accent500 = UIColor(red: 255/255, green: 80/255, blue: 109/255, alpha: 1)
}
