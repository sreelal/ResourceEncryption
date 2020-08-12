//
//  SecureKeys.swift
//  SecureToken
//  
//  Created by Sreelal Hamsavahanan on 22/07/20.
//  Copyright © 2020 EY. All rights reserved.
//

import UIKit

public struct SecureKeys {    
    public var key: [UInt8] {
        return [70, 41, 74, 64, 78, 99, 82, 102, 85, 106, 88, 110, 50, 114, 53, 117]
    }
    
    public var iv: [UInt8] {
        return [56, 120, 47, 65, 63, 68, 40, 71, 43, 75, 98, 80, 101, 83, 104, 86]
    }
}

