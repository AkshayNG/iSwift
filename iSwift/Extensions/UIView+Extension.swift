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
    
    @objc func gradientBackground(withColors colors:[UIColor], maskView:UIView?)
    {
        if hasGradientLayer() { return }
        
        let gradientLayer = CAGradientLayer()
        
        var cgColors:[CGColor] = []
        for color in colors {
            cgColors.append(color.cgColor)
        }
        gradientLayer.colors = cgColors
        
        //Vertical
        //gradientLayer.startPoint = CGPoint.init(x: 0.5, y: 0)
        //gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1)
        
        //Horizontal
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 0.5)
        
        gradientLayer.frame = self.bounds
        gradientLayer.accessibilityHint = "GradientLayer"
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        self.mask = maskView
    }
    
    @objc func gradientBorder(colors:[UIColor], width:CGFloat, radius:CGFloat)
    {
        if hasGradientLayer() { return }
        
        let gradient = CAGradientLayer()
        gradient.frame =  CGRect(origin: CGPoint.zero, size: self.frame.size)
        gradient.startPoint = CGPoint.init(x: 0, y: 0.5)
        gradient.endPoint = CGPoint.init(x: 1.0, y: 0.5)
        gradient.colors = colors.map({$0.cgColor})
        gradient.cornerRadius = radius
        
        let shape = CAShapeLayer()
        shape.lineWidth = width
        shape.path = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: radius).cgPath
        shape.strokeColor = UIColor.black.cgColor
        shape.fillColor = UIColor.clear.cgColor
        
        gradient.mask = shape
        gradient.accessibilityHint = "GradientLayer"
        self.layer.addSublayer(gradient)
    }
    
    @objc func hasGradientLayer() -> Bool
    {
        if let layers = self.layer.sublayers {
            for layer in layers {
                if layer.accessibilityHint == "GradientLayer" {
                    return true
                }
            }
        }
        return false
    }
    
    @objc func removeGradientLayer()
    {
        if let layers = self.layer.sublayers {
            for layer in layers {
                if layer.accessibilityHint == "GradientLayer" {
                    layer.removeFromSuperlayer()
                    break
                }
            }
        }
    }
    
    @objc func flip(toView:UIView)
    {
        let transitionOptions: UIViewAnimationOptions = [.transitionFlipFromRight, .showHideTransitionViews]
        
        UIView.transition(with: self, duration: 1.0, options: transitionOptions, animations: {
            self.isHidden = true
        })
        
        UIView.transition(with: toView, duration: 1.0, options: transitionOptions, animations: {
            toView.isHidden = false
        })
    }
    
    @objc func bounce()
    {
        self.transform = CGAffineTransform.init(scaleX: 0.5, y: 0.5)
        UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.25, initialSpringVelocity: 5.0, options: .allowUserInteraction, animations: {
            self.transform = .identity
        }, completion: nil)
    }
    
    func findFirstResponder() -> UIView?
    {
        if (self.isFirstResponder) {
            return self
        }
        
        for subView in self.subviews {
            let firstResponder = subView.findFirstResponder()
            if firstResponder != nil {
                return firstResponder
            }
        }
        
        return nil
    }
    
    func applyShadow(withRadius radius:CGFloat)
    {
        self.layer.cornerRadius = radius
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 4.0)
        self.layer.shadowOpacity = 0.5
        self.layer.masksToBounds = false
    }
}
