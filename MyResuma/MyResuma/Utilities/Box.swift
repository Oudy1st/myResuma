//
//  Box.swift
//  MyResuma
//
//  Created by Detchat Boonpragob on 11/2/2565 BE.
//


import Foundation

final class Box<T> {
  
  typealias Listener = (T) -> Void
  var listener: Listener?
  
  var value: T {
    didSet {
      listener?(value)
    }
  }
  
  init(_ value: T) {
    self.value = value
  }
  
  func bind(listener: Listener?) {
    self.listener = listener
    listener?(value)
  }
}
