//
//  DBCombinationCondition.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

class DBCombinationCondition: DBCondition {
    enum Operator: String {
        case or = "or"
        case and = "and"
    }
    
    var conditions: [DBCondition] = []
    var `operator`: DBCombinationCondition.Operator
    
    init(conditions: [DBCondition], `operator`: DBCombinationCondition.Operator = .and) {
        self.conditions = conditions
        self.`operator` = `operator`
        super.init()
    }
    
    override func sql() -> String {
        let sql = conditions.map { (c) -> String in
            return "\(c.sql())"
        }.joined(separator: " \(self.`operator`.rawValue) ")
        return sql
    }
    
    override func parameters() -> [String: DBQueryable] {
        var parameters: [String: DBQueryable] = [:]
        for c in self.conditions {
            parameters.merge(c.parameters()) { (v1, v2) -> DBQueryable in
                return v2
            }
        }
        return parameters
    }
}
