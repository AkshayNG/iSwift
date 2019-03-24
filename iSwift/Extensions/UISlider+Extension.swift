//
//  UISlider+Extension.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 24/03/19.
//  Copyright © 2019 yantrana. All rights reserved.
//

import Foundation

extension UISlider {
    var thumbCenterX: CGFloat {
        let trackRect = self.trackRect(forBounds: frame)
        let thumbRect = self.thumbRect(forBounds: bounds, trackRect: trackRect, value: value)
        return thumbRect.midX
    }
}
