//
//  String+Extension.swift
//  All List
//
//  Created by Amol Bapat on 01/12/16.
//  Copyright © 2016 Olive. All rights reserved.
//

import Foundation


extension String
{
    func isValidEmail() -> Bool
    {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isNumeric(minLength:Int, maxLength:Int) -> Bool
    {
        var valid:Bool = false
        
        let badCharacters = NSCharacterSet.decimalDigits.inverted
        
        if(self.rangeOfCharacter(from: badCharacters) == nil)
        {
            valid = true
            
            let count = self.characters.count
            
            if(minLength > 0 || maxLength > 0)
            {
                precondition(minLength < maxLength, "Invalid number range")
               
                if(count >= minLength && count <= maxLength)
                {
                    valid = true
                }
                else
                {
                    valid = false
                }
            }
        }
        
        return valid
    }
    
    func date(format:String) -> Date?
    {
        let formatter = DateFormatter()
        
        formatter.dateFormat = format
        formatter.timeZone = NSTimeZone(abbreviation: "GMT") as! TimeZone   //"GMT+0:00"
        return formatter .date(from: self)
    }
    
   
    func toBool() -> Bool
    {
        switch self
        {
            case "True", "true", "TRUE", "Yes", "yes", "YES", "1":
                return true
            default:
                return false
        }
    }
    
    
    
    
}
