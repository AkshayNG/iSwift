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
    static func randomAlphanumericString(length: Int) -> String {
        let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.length)
        
        var randomString = ""
        
        for _ in 0 ..< length {
            let rand = arc4random_uniform(len)
            var nextChar = letters.character(at: Int(rand))
            randomString += NSString(characters: &nextChar, length: 1) as String
        }
        
        return randomString
    }
    
    // MARK: Validations
    
    func isEmail() -> Bool
    {
        let emailRegEx = "(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"+"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"
        
        let emailTest = NSPredicate(format:"SELF MATCHES[c] %@", emailRegEx)
        return emailTest.evaluate(with: self)
    }
    
    func isURL() -> Bool
    {
        guard let detector = try? NSDataDetector(types: NSTextCheckingResult.CheckingType.link.rawValue) else {
            return false
        }
        
        let result = detector.firstMatch(in: self, options:NSRegularExpression.MatchingOptions(rawValue: 0), range: NSRange(location: 0, length:self.count))
        
        guard let urlStr = result?.url?.absoluteString else { return false }
        
        //1
        if self.contains("http") {
            return self == urlStr
        }
        
        //2
        let prefix:String? = urlStr.contains("https") ? "https://" : (urlStr.contains("http") ? "http://" : nil)
        if prefix != nil {
            let host = (urlStr as NSString).replacingOccurrences(of: prefix!, with: "")
            return self == host
        }
        return self == urlStr
    }
    
    func isAlphanumeric() -> Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
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
    
    // MARK: Operations
    
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
    
    var camelCaseToWords:String
    {
        //e.g. "CamelCase" will be "Camel Case"
        get {
            return unicodeScalars.reduce("") {
                if CharacterSet.uppercaseLetters.contains($1) == true {
                    return ($0 + " " + String($1))
                } else {
                    return $0 + String($1)
                }
            }
        }
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespaces)
    }
    
    // MARK: Phone number
    
    func isPhoneNumber() -> Bool {
        let PHONE_REGEX = "^[+]{1}[0-9]{10,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        var result =  phoneTest.evaluate(with: self)
        if result, self.phoneCountryCode() == nil {
            result = false
        }
        return result
    }
    
    func trimPhoneNumber() -> String {
        let trim = CharacterSet.init(charactersIn:" -_()\0\u{202A}\u{202B}\u{202C}\u{202D}\u{202E}\u{202F}")
        let number = self.components(separatedBy: trim).joined(separator: "")
        return number
    }
    
    func phoneCountryCode() -> String? {
        var cc:String? = nil
        for (_,v) in BRConstants.countryCallCodes {
            let code = "+" + v
            if self.range(of: code) != nil {
                cc = v
                break
            }
        }
        return cc
    }
    
    static func isoCode(forCountry country:String) -> String? {
        var code:String?
        let ctry = country.lowercased()
        let locale = Locale.init(identifier: "en_US")
        for cc in NSLocale.isoCountryCodes {
            if let countryName = locale.localizedString(forRegionCode: cc) {
                print("Country Name :: \(countryName)")
                if countryName.lowercased().contains(ctry) {
                    code = cc
                    break
                }
            }
        }
        return code
    }
    
    static func countryName(forPhoneCode code:String) -> String? {
        let filtered = BRConstants.countryCallCodes.filter { (k,v) -> Bool in
            return v == code
        }
        if filtered.count == 1, let cc = filtered.keys.first {
            let locale = Locale.init(identifier: "en_US")
            let countryName = locale.localizedString(forRegionCode: cc)
            return countryName
        }
        return nil
    }
}

extension NSString
{
    @objc func substringBetween(_ fromString:String, _ toString:String) -> String?
    {
        let scanner = Scanner.init(string: self as String)
        var outputString:NSString?
        if scanner.scanUpTo(fromString, into: nil) {
            scanner.scanString(fromString, into: nil)
            _ = scanner.scanUpTo(toString, into: &outputString)
        }
        return outputString as String?
    }
    
    @objc func isPhoneNumber() -> Bool {
        let PHONE_REGEX = "^[+]{1}[0-9]{10,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
        var result =  phoneTest.evaluate(with: self)
        if result, (self as String).phoneCountryCode() == nil {
            result = false
        }
        return result
    }
}
