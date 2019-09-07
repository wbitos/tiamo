//
//  DBIntervalValueCondition.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

open class DBIntervalValueCondition<T: DBQueryable>: DBCondition {
    public enum Operator: String {
        case between = "betwwen"
    }
    
    open var key: String
    open var value: Interval<T>
    open var `operator`: DBIntervalValueCondition.Operator
    
    public init(key: String, value: Interval<T>, `operator`: DBIntervalValueCondition.Operator = .between) {
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
