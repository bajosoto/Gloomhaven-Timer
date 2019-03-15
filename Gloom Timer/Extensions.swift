//
//  Extensions.swift
//  Gloom Timer
//
//  Created by Sergio Soto on 3/15/19.
//  Copyright © 2019 Sergio Soto. All rights reserved.
//

import Foundation
import UIKit

extension UIView {
    func rotate360Degrees(duration: CFTimeInterval = 4) {
        let rotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        rotateAnimation.fromValue = 0.0
        rotateAnimation.toValue = CGFloat(Double.pi * 2)
        rotateAnimation.isRemovedOnCompletion = false
        rotateAnimation.duration = duration
        rotateAnimation.repeatCount=Float.infinity
        self.layer.add(rotateAnimation, forKey: nil)
    }
}
