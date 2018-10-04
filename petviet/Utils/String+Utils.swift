//
//  String+Utils.swift
//  petviet
//
//  Created by Hai Vu on 9/28/18.
//  Copyright © 2018 csb. All rights reserved.
//

import Foundation
extension String {
    
    public func isPhone()->Bool {
        let phomNumber = self.replacingOccurrences(of: ".", with: "", options: NSString.CompareOptions.literal, range: nil)

        if phomNumber.isAllDigits() == true {
//            let phoneRegex = "[235689][0-9]{6}([0-9]{3})?"
//            let predicate = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
//            return  predicate.evaluate(with: phomNumber)
            return true
        }else {
            return false
        }
    }
    
    private func isAllDigits()->Bool {
        let charcterSet  = NSCharacterSet(charactersIn: "+0123456789").inverted
        let inputString = self.components(separatedBy: charcterSet)
        let filtered = inputString.joined(separator: "")
        return  self == filtered
    }
}
