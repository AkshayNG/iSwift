//
//  AppComm.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 24/03/19.
//  Copyright © 2019 yantrana. All rights reserved.
//

import UIKit

class AppComm:NSObject
{
    static let shared = BRAppCommunication()
    
    enum URLScheme {case http, https, email, phone }
    
    func open(url:String, scheme:URLScheme)
    {
        var prefix = ""
        switch scheme
        {
        case .http:
            prefix = "http://"
            break
            
        case .https:
            prefix = "https://"
            break
            
        case .email:
            prefix = "mailto://"
            break
            
        case .phone:
            prefix = "tel://"
            break
        }
        
        var urlStr = url
        if !(url.hasPrefix(prefix))
        {
            urlStr = prefix + url
        }
        
        if let link = URL.init(string: urlStr), UIApplication.shared.canOpenURL(link)
        {
            if #available(iOS 10.0, *) {
                UIApplication.shared.open(link, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(link)
            }
        }
    }
    
    func openGoogleMapRouteFor(latitude:Double, longitude:Double)
    {
        let mapStr = "maps.google.com/maps?saddr=&daddr=\(latitude),\(longitude)"
        open(url: mapStr, scheme: .https)
    }
    
    
}

