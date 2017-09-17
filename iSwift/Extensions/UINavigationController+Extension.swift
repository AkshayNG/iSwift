//
//  UINavigationController+Extension.swift
//  All List
//
//  Created by Amol Bapat on 05/12/16.
//  Copyright © 2016 Olive. All rights reserved.
//

import UIKit

extension UINavigationController
{
    func pushOrPop(ClassType:UIViewController.Type, nibName:String?, storyboardID:String?, storyboardName:String?, animate:Bool)
    {
        let currentVC = UIApplication.topViewController()
        
        var obj:UIViewController? = nil
        
        let viewControllers = currentVC?.navigationController?.viewControllers
        
        for item in viewControllers!
        {
            if(item .isKind(of: ClassType))
            {
                obj = item
                break
            }
        }
        
        if(obj != nil)
        {
            print("Popping ...")
            _ = currentVC?.navigationController?.popToViewController(obj!, animated: animate)
        }
        else
        {
            print("Pushing...")
            if(nibName != nil)
            {
                let myVC = ClassType.init(nibName: nibName, bundle: nil)
                currentVC?.navigationController?.pushViewController(myVC, animated: animate)
                
            }
            else if(storyboardID != nil)
            {
                if(storyboardName == nil)
                {
                    fatalError("Storyboard Name not specified")
                }
                
                let mainStoryboard:UIStoryboard = UIStoryboard.init(name: storyboardName!, bundle: nil)
                let myVC = mainStoryboard.instantiateViewController(withIdentifier: storyboardID!)
                currentVC?.navigationController?.pushViewController(myVC, animated: true)
            }
            else
            {
                let myVC = ClassType.init()
                currentVC?.navigationController?.pushViewController(myVC, animated: animate)
            }
        }
    }
}
