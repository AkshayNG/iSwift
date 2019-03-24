//
//  UIViewController+Extension.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 24/03/19.
//  Copyright © 2019 yantrana. All rights reserved.
//

import UIKit

extension UIViewController
{
    func simpleAlert(withTitle title:String?, message:String?, handleAction:((UIAlertAction)->Void)?)
    {
        let alert = UIAlertController.init(title:title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction.init(title: "OK", style: .cancel , handler: handleAction))
        self.present(alert, animated: true, completion: nil)
    }
}

