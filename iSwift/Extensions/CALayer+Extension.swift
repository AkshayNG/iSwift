//
//  CALayer+Extension.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 24/03/19.
//  Copyright © 2019 yantrana. All rights reserved.
//

import Foundation

extension CALayer {
    var borderUIColor: UIColor {
        set {
            self.borderColor = newValue.cgColor
        }
        
        get {
            return UIColor(cgColor: self.borderColor!)
        }
    }
}
