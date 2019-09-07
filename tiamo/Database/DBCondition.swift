//
//  DBCondition.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

open class DBCondition: NSObject {
    open func build() -> (String, [String: DBQueryable]) {
        return (self.sql(), self.parameters())
    }
    
    open func sql() -> String {
        return ""
    }
    
    open func parameters() -> [String: DBQueryable] {
        return [:]
    }
}
