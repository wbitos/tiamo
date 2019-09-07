//
//  DBMultValueCondition.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

open class DBMultValueCondition: DBCondition {
    public enum Operator: String {
        case `in` = "in"
    }
    
    open var key: String
    open var value: MultValue
    open var `operator`: DBMultValueCondition.Operator
    
    public init(key: String, value: MultValue, `operator`: DBMultValueCondition.Operator = .`in`) {
        self.key = key
        self.value = value
        self.`operator` = `operator`
        
        super.init()
    }
    
//    override func sql() -> String {
//        let sql = "\(self.key) \(self.`operator`) :\(self.key)"
//        return sql
//    }
//    
//    override func parameters() -> [String: DBQueryable] {
//        return [:]
//    }
}
