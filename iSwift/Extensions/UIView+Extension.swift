//
//  UIView+Extension.swift
//  All List
//
//  Created by Amol Bapat on 30/11/16.
//  Copyright © 2016 Olive. All rights reserved.
//

import UIKit

extension UIView
{
    
    /*
        + (void) moveViewInVC:(UIViewController*)callingView up:(BOOL)movedUp by:(float)distance;
        {
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:0.3];
            
            CGRect rect = callingView.view.frame;
            if (movedUp)
            {
            rect.origin.y -= distance;
            }
            else
            {
            rect.origin.y += distance;
            }
            callingView.view.frame = rect;
            
            [UIView commitAnimations];
        
        }
     */
    
    
    func moveUp(distance:CGFloat)
    {
        var rect = self.frame
        rect.origin.y -= distance
        
        UIView.animate(withDuration: 0.3) { 
            self.frame = rect;
        }
    }
    
    func moveDown(distance:CGFloat)
    {
        var rect = self.frame
        rect.origin.y += distance
        
        UIView.animate(withDuration: 0.1) {
            self.frame = rect;
        }
    }
    
    
  
}



