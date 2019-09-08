//
//  DBColumn.swift
//  Tiamo
//
//  Created by suyu on 2019/9/8.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

open class DBColumn: NSObject {
    open var name: String
    open var type: String
    open var primary: Bool = false
    open var auto: Bool = false
    open var nullable: Bool = false
    
    public init(name: String, type: String, primary: Bool = false, auto: Bool = false, nullable: Bool = false) {
        self.name = name
        self.type = type
        self.primary = primary
        self.auto = auto
        self.nullable = nullable
        super.init()
    }
}
