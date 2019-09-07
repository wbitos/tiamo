//
//  Version.swift
//  tiamo
//
//  Created by suyu on 2019/9/7.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

public class Version: Model, Record {
    public var createdAt: Date = Date()
    public var updatedAt: Date = Date()
    
    var version: Int = 0
}
