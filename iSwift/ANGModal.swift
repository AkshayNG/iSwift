//
//  ANGModal.swift
//  All List
//
//  Created by Amol Bapat on 16/12/16.
//  Copyright © 2016 Olive. All rights reserved.
//

import UIKit


@objc protocol ANGModalDelegate
{
    @objc optional func willPresentModal(modal:ANGModal)
    @objc optional func didPresentModal(modal:ANGModal)
    @objc optional func willDismissModal(modal:ANGModal)
    @objc optional func didDismissModal(modal:ANGModal)
}

class ANGModal: UIView, UIGestureRecognizerDelegate
{
    var delegate:ANGModalDelegate?
    
    private let DEVICE_WIDTH = UIScreen.main.bounds.size.width
    private let DEVICE_HEIGHT = UIScreen.main.bounds.size.height

    private var displayView:UIView
    private var animation:Bool
    
    var cornerRadius:CGFloat = 0.0
    var tapToDismiss:Bool = true
    var hideCloseButton:Bool = true
    var closeButtonColor:UIColor?
    
    
    init(view:UIView, frame:CGRect)
    {
        self.displayView = view
        displayView.frame = frame
        animation = true
        super.init(frame: frame)
        self.frame = CGRect(x:0, y:0, width:DEVICE_WIDTH, height:DEVICE_HEIGHT)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.8)
    }
    
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect)
    {
        self.delegate?.willPresentModal?(modal: self)
        
        super.draw(rect)
        
        displayView.layer.cornerRadius = self.cornerRadius
        
        if(tapToDismiss)
        {
            let tapGesture = UITapGestureRecognizer.init(target: self, action: #selector(dismiss))
            tapGesture.delegate = self
            tapGesture.numberOfTapsRequired = 1
            self.addGestureRecognizer(tapGesture)
        }
        
        if(!hideCloseButton)
        {
            let closeBtn = UIButton.init(type: .custom)
            closeBtn.frame = CGRect(x:displayView.frame.size.width-30, y:0, width:30, height:30)
            closeBtn.setTitle("X", for: .normal)
            closeBtn.setTitleColor(UIColor.white, for: .normal)
            closeBtn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20.0)
            closeBtn.layer.borderColor = UIColor.white.cgColor
            closeBtn.layer.borderWidth = 2.0;
            closeBtn.layer.cornerRadius = 15.0;
            closeBtn.layer.zPosition = 1.0;
            closeBtn.clipsToBounds = true;
            
            if(self.closeButtonColor != nil)
            {
                closeBtn.backgroundColor = closeButtonColor
            }
            else
            {
                closeBtn.backgroundColor = UIColor.gray
            }
            
            closeBtn .addTarget(self, action: #selector(dismiss), for: .touchUpInside)
            
            displayView.addSubview(closeBtn)
        }
        

        self .present(animate: animation)
    }
 
    
    func present(animate:Bool)
    {
        animation = animate
        
        let show =
        {
            if(animate == true)
            {
                self.displayView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001);
                
                self.addSubview(self.displayView)
                
                UIView.animate(withDuration: 1.0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0, options: UIViewAnimationOptions(rawValue: UInt(0)), animations: {
                    
                        self.displayView.transform = .identity
                    
                    }, completion: { (finished) in
                       
                        self.delegate?.didPresentModal?(modal: self)
                })
            }
            else
            {
                self.addSubview(self.displayView)
                
                self.delegate?.didPresentModal?(modal: self)
            }
        }
        
        if let topVC = self.currentVC()
        {
            if (self.isDescendant(of: topVC.view) == false)
            {
                topVC.view .addSubview(self)
            }
            else
            {
                show()
            }
        }
        else
        {
            show()
        }
    }
    
    func dismiss(animate:Bool)
    {
        self.delegate?.willDismissModal?(modal: self)
        
        if(animate == true || animation == true)
        {
            UIView.animate(withDuration: 0.3, animations: {
                
                self.displayView.transform = CGAffineTransform(scaleX: 0.001, y: 0.001);
                
                }, completion: { (finished) in
                    
                    self.removeFromSuperview()
                    
                    self.delegate?.didDismissModal?(modal: self)

            })
        }
        else
        {
            self.removeFromSuperview()
            
            self.delegate?.didDismissModal?(modal: self)
        }
    }
    
    private func currentVC(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return currentVC(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return currentVC(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return currentVC(base: presented)
        }
        return base
    }
    
    // MARK - Tap gesture
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let touchPoint = touch.location(in: self)
        
        //return !(displayView.point(inside: touchPoint, with: nil))
        
        return !(displayView.frame.contains(touchPoint))
    }
    
    /*
    - (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    CGPoint touchPoint = [touch locationInView:self];
    return !CGRectContainsPoint(displayView.frame, touchPoint);
    }
 */

}
