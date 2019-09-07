//
//  DBMultValueCondition.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

class DBMultValueCondition: DBCondition {
    enum Operator: String {
        case `in` = "in"
    }
    
    var key: String
    var value: MultValue
    var `operator`: DBMultValueCondition.Operator
    
    init(key: String, value: MultValue, `operator`: DBMultValueCondition.Operator = .`in`) {
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
