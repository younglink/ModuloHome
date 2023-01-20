//
//  GradientCircularSlider.swift
//
//  Created by Christopher Olsen on 03/03/16.
//  Copyright © 2016 Christopher Olsen. All rights reserved.
//

import UIKit

class GradientCircularSlider: CircularSlider {
  // Array with two colors to create gradation between
  var unfilledGradientColors: [UIColor] = [.black, .lightGray] {
    didSet {
      setNeedsDisplay()
    }
  }
  
  override func drawLine(_ ctx: CGContext) {
    if unfilledGradientColors.count == 2 {
      CircularTrig.drawUnfilledGradientArcInContext(ctx, center: centerPoint, radius: computedRadius, lineWidth: CGFloat(lineWidth), maximumAngle: maximumAngle , colors: unfilledGradientColors, lineCap: unfilledArcLineCap)
    }
  }
}
