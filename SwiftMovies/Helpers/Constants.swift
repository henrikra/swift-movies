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
  static let primary500 = UIColor(red: 39/255, green: 44/255, blue: 64/255, alpha: 1)
  static let secondary500 = UIColor(red: 80/255, green: 94/255, blue: 121/255, alpha: 1)
  static let accent500 = UIColor(red: 39/255, green: 177/255, blue: 220/255, alpha: 1)
}
