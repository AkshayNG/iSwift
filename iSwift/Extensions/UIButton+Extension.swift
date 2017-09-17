//
//  UIButton+Extension.swift
//  All List
//
//  Created by Amol Bapat on 29/12/16.
//  Copyright © 2016 Olive. All rights reserved.
//

import UIKit

extension UIButton
{
    func enable()
    {
        self.alpha = 1.0
        self.isEnabled = true
        self.isUserInteractionEnabled = true
        
    }
    
    func disable()
    {
        self.isEnabled = false
        self.isUserInteractionEnabled = false
        self.alpha = 0.5
    }
}
