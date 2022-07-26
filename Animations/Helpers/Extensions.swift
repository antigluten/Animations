//
//  Extensions.swift
//  Animations
//
//  Created by Vladimir Gusev on 26.07.2022.
//

import UIKit

extension UIImage {
    convenience init?(item: Item) {
    self.init(named: item.rawValue)
  }
}

extension UIImageView {
  convenience init(item: Item) {
    self.init( image: .init(item: item) )
  }
}
