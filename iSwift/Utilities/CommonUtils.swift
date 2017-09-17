//
//  CommonUtils.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 09/05/17.
//  Copyright © 2017 yantrana. All rights reserved.
//

import UIKit

class CommonUtils: NSObject
{
    static func alert(title:String?, message:String?)
    {
        if IOS_VERSION >= 8.0
        {
            let alertController = UIAlertController.init(title: title, message: message, preferredStyle: .alert)
            
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            
            UIApplication.topViewController()?.present(alertController, animated: true, completion: nil)
        }
        else
        {
            let alertView = UIAlertView.init(title: title, message: message, delegate: self, cancelButtonTitle: "OK")
            alertView.show()
        }
    }
    
    static func truncateDocumentDirectory()
    {
        let fM = FileManager()
        let ddPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
        
        if let contentPaths = try? fM.contentsOfDirectory(atPath: ddPath)
        {
            for path in contentPaths
            {
                let fullPath = ddPath.appending("/"+path)
                if((try? fM .removeItem(atPath: fullPath)) != nil)
                {
                    print("Removed item from document directory ...")
                }
                else
                {
                    print("Unable to remove item from document directory ...")
                }
            }
        }
    }


}
