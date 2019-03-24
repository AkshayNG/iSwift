//
//  UIImageView+Extension.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 24/03/19.
//  Copyright © 2019 yantrana. All rights reserved.
//

import Foundation

func downloadImage(imageURL:URL,
                   placeholderImage:UIImage?,
                   cachePolicy:NSURLRequest.CachePolicy,
                   finished: (() -> Void)?)
{
    self.image = placeholderImage
    
    let request = URLRequest.init(url: imageURL, cachePolicy: cachePolicy, timeoutInterval: 60.0)
    
    URLSession.shared.dataTask(with: request) { (data, response, error) in
        if(error == nil)
        {
            if(data != nil)
            {
                DispatchQueue.main.async {
                    self.image = UIImage.init(data: data!)
                    if(finished != nil) { finished!() }
                }
            }
            else
            {
                print("Error downloading image ::  Data not found")
                if(finished != nil) { finished!() }
            }
        }
        else
        {
            print("Error downloading image ::  %@",error!.localizedDescription)
            if(finished != nil) { finished!() }
        }
        }.resume()
}
