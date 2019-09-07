//
//  DBCondition.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

class DBCondition: NSObject {
    func build() -> (String, [String: DBQueryable]) {
        return (self.sql(), self.parameters())
    }
    
    func sql() -> String {
        return ""
    }
    
    func parameters() -> [String: DBQueryable] {
        return [:]
    }
}
