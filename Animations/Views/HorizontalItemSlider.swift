//
//  HorizontalItemSlider.swift
//  Animations
//
//  Created by Vladimir Gusev on 23.07.2022.
//

import UIKit

class HorizontalItemSlider: UIScrollView {

    typealias HandleTap = (Item) -> Void
 
    init(in view: UIView, handleTap: @escaping HandleTap) {
      super.init(
        frame: .init(x: 0, y: 120, width: view.frame.width, height: 80)
      )

      let buttonWidth: CGFloat = 60

      for (index, item) in Item.allCases.enumerated() {
        let imageView = UIImageView(item: item)
        imageView.center = CGPoint(
          x: CGFloat(index) * buttonWidth + buttonWidth / 2,
          y: buttonWidth / 2
        )
        imageView.isUserInteractionEnabled = true

        addSubview(imageView)

        imageView.addGestureRecognizer(
          TapGestureRecognizer { handleTap(item) }
        )
      }

      let padding: CGFloat = 10
      contentSize = CGSize(
        width: padding * buttonWidth,
        height:  buttonWidth + 2 * padding
      )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
