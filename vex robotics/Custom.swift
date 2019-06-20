//
//  Custom.swift
//  VEX Robotics
//
//  Created by Aaron Whitfield on 12/22/14.
//  Copyright (c) 2014 Aaron Whitfield. All rights reserved.
//

import Foundation
import UIKit

extension String
{
    func isEmail() -> Bool
    {
        let regex = NSRegularExpression(pattern: "^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$", options: .CaseInsensitive, error: nil)
        
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, countElements(self))) != nil
    }
    
    func isNumeric() -> Bool
    {
        let regex = NSRegularExpression(pattern: "^[0-9]$", options: .CaseInsensitive, error: nil)
        
        return regex?.firstMatchInString(self, options: nil, range: NSMakeRange(0, countElements(self))) != nil
    }
}

