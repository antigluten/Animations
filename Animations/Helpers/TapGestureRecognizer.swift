//
//  TapGestureRecognizer.swift
//  Animations
//
//  Created by Vladimir Gusev on 23.07.2022.
//

import UIKit

public final class TapGestureRecognizer: UITapGestureRecognizer {
  public init(_ perform: @escaping () -> Void) {
    self.perform = .init(perform)
    super.init(target: self.perform, action: self.perform.selector)
  }

  public let perform: Selector.Perform
}
