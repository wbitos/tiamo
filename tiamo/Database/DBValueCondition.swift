//
//  DBValueCondition.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

open class DBValueCondition: DBCondition {
    public enum Operator: String {
        case equal = "="
        case unEqual = "!="
        
        case greater = ">"
        case greaterOrEqual = ">="
        
        case lesser = "<"
        case lesserOrEqual = "<="
        
        case like = "like"
    }
    
    open var key: String
    open var value: DBQueryable
    open var `operator`: DBValueCondition.Operator
    
    public init(key: String, value: DBQueryable, `operator`: DBValueCondition.Operator = .equal) {
        self.key = key
        self.value = value
        self.`operator` = `operator`
        
        super.init()
    }
    
    override open func sql() -> String {
        let sql = "\(self.key) \(self.`operator`.rawValue) :\(self.key)"
        return sql
    }
    
    override open func parameters() -> [String: DBQueryable] {
        return [self.key: self.value.sqlValue()]
    }
}
