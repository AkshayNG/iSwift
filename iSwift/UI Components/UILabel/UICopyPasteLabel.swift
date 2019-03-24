//
//  UICopyableLabel.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 24/03/19.
//  Copyright © 2019 yantrana. All rights reserved.
//

import UIKit

class UICopyPasteLabel: UILabel {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    @IBInspectable var copyingEnabled: Bool {
        get {
            return self.copyingEnabled
        }
        set (val){
            if val {
                self.setupLongPress()
            }
        }
    }
    
    @IBInspectable var pastingEnabled : Bool {
        get {
            return self.copyingEnabled
        }
        set (val){
            if val {
                self.setupLongPress()
            }
        }
    }
    
    private var longPress:UILongPressGestureRecognizer?

    override var canBecomeFirstResponder: Bool {
        return self.copyingEnabled || self.pastingEnabled
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        if action == "copy:", (self.text?.count ?? 0) > 0 {
            return self.copyingEnabled
        }
        
        if action == "paste:", UIPasteboard.general.string != nil {
            return self.pastingEnabled
        }
        
        return false
    }
    
    func copy(_ sender: Any?) {
        if self.copyingEnabled {
            UIPasteboard.general.string = self.text
        }
    }
    
    func paste(_ sender: Any?) {
        if self.pastingEnabled, let strToPaste = UIPasteboard.general.string {
            let trimChars = CharacterSet.init(charactersIn: " -_()\0\u{202A}\u{202B}\u{202C}\u{202D}\u{202E}\u{202F}")
            let pasteStr = strToPaste.components(separatedBy: trimChars).joined(separator: "")
            self.text = pasteStr
        }
    }
    
    private func setupLongPress() {
        if longPress == nil {
            self.isUserInteractionEnabled = true
            longPress = UILongPressGestureRecognizer.init(target: self, action: #selector(longPressGestureRecognized(gestureRecognizer:)))
            longPress?.minimumPressDuration = 0.25
            self.addGestureRecognizer(longPress)
        }
    }
    
    private func longPressGestureRecognized(gestureRecognizer:UIGestureRecognizer) {
        gestureRecognizer.state == .began {
            self.becomeFirstResponder()
            let menuController = UIMenuController.shared
            menuController.setTargetRect(self.bounds, in: self)
            menuController.arrowDirection = .default
            menuController.setMenuVisible(true, animated: true)
        }
    }
}
