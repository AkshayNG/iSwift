//
//  UIMoreTextLabel.swift
//  iSwift
//
//  Created by Akshay Gajarlawar on 24/03/19.
//  Copyright © 2019 yantrana. All rights reserved.
//

import UIKit

class UIMoreTextLabel: UILabel, UIGestureRecognizerDelegate {

    var onTapMoreText: (() -> Void)?
    
    private var rangeOfMoreText:NSRange?
    private var isAddedMoreText = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func set(moreText text:String, withAction action:(() -> Void)?) {
        self.addMoreText(moreText: text)
        self.onTapMoreText = action
    }
    
    func visibleText()-> String?
    {
        guard let fullText = text else { return nil }
        var textVisible = fullText
        let sizeConstraint = CGSize.init(width: frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        for i in 1...(fullText.count - 1) {
            let subStr = (fullText as NSString).substring(to: i)
            let attributedText = NSAttributedString.init(string: subStr, attributes: [NSAttributedStringKey.font : font])
            let boundingRect = attributedText.boundingRect(with: sizeConstraint, options: .usesLineFragmentOrigin, context: nil)
            
            if boundingRect.height > frame.size.height {
                break
            }
            textVisible = subStr
        }
        
        return textVisible
    }
    
    private func addMoreText(moreText:String)
    {
        if isAddedMoreText { return }
        guard let textVisible = self.visibleText() else { return }
        
        let appendText = "... \(moreText)"
        let range = NSRange.init(location: textVisible.count - (appendText.count+2), length: appendText.count+2)
        if range.location == NSNotFound { return }
        let newText = (textVisible as NSString).replacingCharacters(in: range, with: appendText)
        let moreRange = NSRange.init(location: newText.count - moreText.count, length: moreText.count)
        let attrText = NSMutableAttributedString.init(string: newText)
        attrText.addAttribute(NSAttributedStringKey.foregroundColor, value: UIColor.colorFromHexString(hex:"4286f4"), range: moreRange)
        self.attributedText = attrText
        
        rangeOfMoreText = moreRange
        isAddedMoreText = true
        
        self.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(labelTapped(tapGesture:)))
        tap.numberOfTapsRequired = 1
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }
    
    @objc private func labelTapped(tapGesture:UITapGestureRecognizer)
    {
        if(didTapMoreText(gesture: tapGesture)) {
            if let callback = self.onTapMoreText {
                callback()
            }
        }
    }
    
    private func didTapMoreText(gesture:UITapGestureRecognizer) -> Bool
    {
        guard let targetRange = rangeOfMoreText else { return false }
        guard let attrString = self.attributedText else { return false }
        
        let layoutManager = NSLayoutManager()
        let textContainer = NSTextContainer(size: .zero)
        let textStorage = NSTextStorage(attributedString: attrString)
        
        layoutManager.addTextContainer(textContainer)
        textStorage.addLayoutManager(layoutManager)
        
        textContainer.lineFragmentPadding = 0
        textContainer.lineBreakMode = self.lineBreakMode
        textContainer.maximumNumberOfLines = self.numberOfLines
        let labelSize = self.bounds.size
        textContainer.size = labelSize
        
        let locationOfTouchInLabel = gesture.location(in: self)
        let textBoundingBox = layoutManager.usedRect(for: textContainer)
        let textContainerOffset = CGPoint(x: (labelSize.width - textBoundingBox.size.width) * 0.5 - textBoundingBox.origin.x, y: (labelSize.height - textBoundingBox.size.height) * 0.5 - textBoundingBox.origin.y)
        let locationOfTouchInTextContainer = CGPoint(x: locationOfTouchInLabel.x - textContainerOffset.x, y: locationOfTouchInLabel.y - textContainerOffset.y)
        let indexOfCharacter = layoutManager.characterIndex(for: locationOfTouchInTextContainer, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        let inRange = NSLocationInRange(indexOfCharacter, targetRange)
        
        if inRange {
            let attributedString = NSMutableAttributedString(attributedString: attrString)
            attributedString.addAttributes([.backgroundColor: UIColor.lightGray.withAlphaComponent(0.5)], range: targetRange)
            attributedText = attributedString
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.indicateState(attributedString)
                self.setNeedsDisplay()
            }
        }
        
        return inRange
    }
    
    private func indicateState(_ attributedString: NSMutableAttributedString) {
        guard let targetRange = rangeOfMoreText else { return  }
        attributedString.addAttributes([.backgroundColor: UIColor.clear], range: targetRange)
        attributedText = attributedString
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
