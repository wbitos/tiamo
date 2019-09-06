//
//  DBLimit.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

class DBLimit: NSObject {
    var offset: Int64 = 0
    var count: Int64 = 0
    
    init(offset: Int64 = 0, count: Int64 = 100) {
        self.offset = offset
        self.count = count
        super.init()
    }
}
