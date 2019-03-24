//
//  UIImage+Extension.swift
//  All List
//
//  Created by Amol Bapat on 30/01/17.
//  Copyright © 2017 Olive. All rights reserved.
//

import UIKit

public extension UIImage
{
    public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1))
    {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
    
    func alpha(value:CGFloat)->UIImage
    {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        draw(at: CGPoint.zero, blendMode: .normal, alpha: value)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    func toBase64String(isPNG:Bool) -> String?
    {
        if isPNG {
            if let pngData = UIImagePNGRepresentation(self) {
                return pngData.base64EncodedString()
            }
        } else {
            if let jpgData = UIImageJPEGRepresentation(self, 1.0) {
                return jpgData.base64EncodedString()
            }
        }
        return nil
    }
    
    static func thumbnail(forVideoURL url: URL) -> UIImage? {
        do {
            let asset = AVURLAsset(url: url)
            let imageGenerator = AVAssetImageGenerator(asset: asset)
            imageGenerator.appliesPreferredTrackTransform = true
            let cgImage = try imageGenerator.copyCGImage(at: kCMTimeZero, actualTime: nil)
            return UIImage(cgImage: cgImage)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

}
