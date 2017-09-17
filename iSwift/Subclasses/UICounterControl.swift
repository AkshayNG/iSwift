//
//  UICounterController.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 09/05/17.
//  Copyright © 2017 yantrana. All rights reserved.
//

import UIKit

class UICounterControl: UIView
{
    var minValue:NSInteger = 0
    var maxValue:NSInteger = 0
    var controlColor:UIColor = UIColor.gray
    var controlTextColor:UIColor = UIColor.white
    var counterColor:UIColor = UIColor.lightGray
    var counterTextColor:UIColor = UIColor.black
    var minusImage:UIImage?
    var plusImage:UIImage?
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        if(frame.size.height < frame.size.width/3)
        {
            fatalError("init(frame:) INVALID : Frame width (\(frame.size.width)) must be at least thrice the frame height(\(frame.size.height)) . e.g frame must have width >= (height * 3)")
        }
        
        self.clipsToBounds = true
        self.backgroundColor = UIColor.yellow
        self.layer.cornerRadius = 5.0
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        /*** Left Contol ***/
        let minusBtn = UIButton.init(type: .custom)
        minusBtn.backgroundColor = controlColor
        minusBtn.frame = CGRect(x:1,
                                y:1,
                                width:rect.size.height - 2,
                                height:rect.size.height - 2)
        if(minusImage != nil)
        {
            minusBtn .setImage(minusImage, for: .normal)
        }
        else
        {
            minusBtn.setTitle("-", for: .normal)
            minusBtn.setTitleColor(controlTextColor, for: .normal)
            minusBtn.titleLabel?.font = UIFont.systemFont(ofSize: minusBtn.frame.size.height/2)
        }
        
        
        /*** Right Contol ***/
        let plusBtn = UIButton.init(type: .custom)
        plusBtn.backgroundColor = controlColor
        let plusX = rect.size.width - (minusBtn.frame.size.width + 1)
        plusBtn.frame = CGRect(x:plusX,
                               y:minusBtn.frame.origin.y,
                               width:minusBtn.frame.size.width,
                               height:minusBtn.frame.size.height)
        if(plusImage != nil)
        {
            plusBtn .setImage(plusImage, for: .normal)
        }
        else
        {
            plusBtn.setTitle("+", for: .normal)
            plusBtn.setTitleColor(controlTextColor, for: .normal)
            plusBtn.titleLabel?.font = UIFont.systemFont(ofSize: plusBtn.frame.size.height/2)
        }
        
        
        /*** COUNTER ***/
        let counterLbl = UILabel.init()
        let counterX = minusBtn.frame.size.width + 2
        let counterWidth = rect.size.width - ( minusBtn.frame.size.width*2 + 4)
        counterLbl.frame = CGRect(x:counterX,
                                  y:minusBtn.frame.origin.y,
                                  width:counterWidth,
                                  height:minusBtn.frame.size.height)
        counterLbl.backgroundColor = counterColor
        counterLbl.textColor = counterTextColor
        
        
        /*** Add ***/
        self.addSubview(minusBtn)
        self.addSubview(plusBtn)
        self.addSubview(counterLbl)
    }
}

