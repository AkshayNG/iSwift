//
//  DayCell.swift
//  Self Drive
//
//  Created by Amol Bapat on 12/01/17.
//  Copyright © 2017 Olive. All rights reserved.
//

import UIKit

class DayCell: UICollectionViewCell
{    
    var numberLbl:UILabel = UILabel()
    var makeCircular:Bool = true
    
    let scale:CGFloat = 5.0
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        let label = UILabel.init(frame: CGRect(x:frame.size.height/2 - (frame.size.height-scale)/2,
                                               y:frame.size.height/2 - (frame.size.height-scale)/2,
                                               width:frame.size.height-scale,
                                               height:frame.size.height-scale))
        
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.textAlignment = .center
        
        
        
        numberLbl = label
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect)
    {
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.clear.cgColor
        
        if(makeCircular)
        {
            numberLbl.clipsToBounds = true
            numberLbl.layer.cornerRadius = (rect.size.height-scale)/2
        }
        
        self.contentView.addSubview(numberLbl)
    }
}
