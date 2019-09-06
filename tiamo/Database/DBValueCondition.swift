//
//  DBValueCondition.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

class DBValueCondition: DBCondition {
    enum Operator: String {
        case equal = "="
        case unEqual = "!="
        
        case greater = ">"
        case greaterOrEqual = ">="
        
        case lesser = "<"
        case lesserOrEqual = "<="
        
        case like = "like"
    }
    
    var key: String
    var value: DBQueryable
    var `operator`: DBValueCondition.Operator
    
    init(key: String, value: DBQueryable, `operator`: DBValueCondition.Operator = .equal) {
        self.key = key
        self.value = value
        self.`operator` = `operator`
        
        super.init()
    }
    
    override func sql() -> String {
        let sql = "\(self.key) \(self.`operator`) :\(self.key)"
        return sql
    }
    
    override func parameters() -> [String: DBQueryable] {
        return [self.key: self.value.sqlValue()]
    }
}
