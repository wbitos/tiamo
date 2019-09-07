//
//  Version.swift
//  tiamo
//
//  Created by suyu on 2019/9/7.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

class Version: Model, Record {
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    
    var version: Int = 0
}
