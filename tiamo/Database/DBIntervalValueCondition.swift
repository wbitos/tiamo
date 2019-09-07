//
//  DBIntervalValueCondition.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

class DBIntervalValueCondition<T: DBQueryable>: DBCondition {
    enum Operator: String {
        case between = "betwwen"
    }
    
    var key: String
    var value: Interval<T>
    var `operator`: DBIntervalValueCondition.Operator
    
    init(key: String, value: Interval<T>, `operator`: DBIntervalValueCondition.Operator = .between) {
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
