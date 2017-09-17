//
//  UIApplication+Extension.swift
//  All List
//
//  Created by Amol Bapat on 30/11/16.
//  Copyright © 2016 Olive. All rights reserved.
//

import UIKit

extension UIApplication
{
    class func topViewController(base: UIViewController? = (UIApplication.shared.delegate as! AppDelegate).window?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    
    class func callNumber(phoneNumber:String) -> Bool
    {
        if let phoneCallURL = URL.init(string: "tel://\(phoneNumber)")
        {
            if (self.shared.canOpenURL(phoneCallURL))
            {
                self.shared.openURL(phoneCallURL);
                return true
            }
            else
            {
                print("Application failed to open phone URL")
                return false
            }
        }
        else
        {
            return false
        }
    }
}
