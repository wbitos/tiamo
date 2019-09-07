//
//  DBCombinationCondition.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

open class DBCombinationCondition: DBCondition {
    public enum Operator: String {
        case or = "or"
        case and = "and"
    }
    
    open var conditions: [DBCondition] = []
    open var `operator`: DBCombinationCondition.Operator
    
    public init(conditions: [DBCondition], `operator`: DBCombinationCondition.Operator = .and) {
        self.conditions = conditions
        self.`operator` = `operator`
        super.init()
    }
    
    override open func sql() -> String {
        let sql = conditions.map { (c) -> String in
            return "\(c.sql())"
        }.joined(separator: " \(self.`operator`.rawValue) ")
        return sql
    }
    
    override open func parameters() -> [String: DBQueryable] {
        var parameters: [String: DBQueryable] = [:]
        for c in self.conditions {
            parameters.merge(c.parameters()) { (v1, v2) -> DBQueryable in
                return v2
            }
        }
        return parameters
    }
}
