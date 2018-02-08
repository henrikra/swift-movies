//
//  Debouncer.swift
//  SwiftMovies
//
//  Created by Henrik Raitasola on 08/02/2018.
//  Copyright © 2018 Henrik Raitasola. All rights reserved.
//

import Foundation

class Debouncer: NSObject {
  var callback: (() -> ())
  var delay: Double
  weak var timer: Timer?
  
  init(delay: Double, callback: @escaping (() -> ())) {
    self.delay = delay
    self.callback = callback
  }
  
  func call() {
    timer?.invalidate()
    let nextTimer = Timer.scheduledTimer(timeInterval: delay, target: self, selector: #selector(Debouncer.fireNow), userInfo: nil, repeats: false)
    timer = nextTimer
  }
  
  @objc func fireNow() {
    self.callback()
  }
}
