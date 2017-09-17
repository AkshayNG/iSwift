//
//  UIControl+Extension.swift
//  All List
//
//  Created by Amol Bapat on 30/11/16.
//  Copyright © 2016 Olive. All rights reserved.
//

import UIKit
import ObjectiveC

var ActionHandlerKey: UInt8 = 0

typealias ActionBlock = (_ sender: UIControl) -> Void

class ActionBlockWrapper : NSObject
{
    var block : ActionBlock
    init(block: @escaping ActionBlock)
    {
        self.block = block
    }
}

extension UIControl
{
    func setAction(block: @escaping ActionBlock, controlEvents:UIControlEvents)
    {
        objc_setAssociatedObject(self, &ActionHandlerKey, ActionBlockWrapper(block: block), objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        self.addTarget(self, action: #selector(handleAction(sender:)), for: controlEvents)
    }
    
    func handleAction(sender: UIControl) {
        let wrapper = objc_getAssociatedObject(self, &ActionHandlerKey) as! ActionBlockWrapper
        wrapper.block(sender)
    }
}

/*
 e.g.
 
button.setAction(block: { (sender) in
    
    _ = self.navigationController?.popViewController(animated: true)
    
    }, controlEvents: .touchUpInside)

textField.setAction(block: { (sender) in
    print(textField.text)
    }, controlEvents: .editingChanged)
*/



