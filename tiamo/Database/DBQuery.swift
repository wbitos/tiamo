//
//  DBQuery.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation
import FMDB

class DBQuery: NSObject {
    var table: String
    var connection: FMDatabaseQueue

    var condition: DBCondition?
    var orderby: [DBOrderby] = []
    var limit: DBLimit?
    
    var select: [String]? = nil

    init(connection: FMDatabaseQueue, table: String) {
        self.connection = connection
        self.table = table
        super.init()
    }

    func select(_ columbs: [String]? = nil) -> Self {
        self.select = columbs
        return self
    }
    
    func `where`(_ key: String, `operator`: DBValueCondition.Operator = .equal, value: DBQueryable) -> Self {
        self.condition = DBValueCondition(key: key, value: value, operator: `operator`)
        return self
    }
    
    func orWhere(_ key: String, `operator`: DBValueCondition.Operator = .equal, value: DBQueryable) -> Self {
        guard let prev = self.condition else {
            return self
        }
        
        let current = DBValueCondition(key: key, value: value, operator: `operator`)
        self.condition = DBCombinationCondition(conditions: [prev, current], operator: .or)
        return self
    }
    
    func andWhere(_ key: String, `operator`: DBValueCondition.Operator = .equal, value: DBQueryable) -> Self {
        guard let prev = self.condition else {
            return self
        }
        
        let current = DBValueCondition(key: key, value: value, operator: `operator`)
        self.condition = DBCombinationCondition(conditions: [prev, current], operator: .and)
        return self
    }
    
    func orderby(_ key: String, order: DBOrderby.Order) -> Self {
        let orderby = DBOrderby(key, order: order)
        self.orderby.append(orderby)
        return self
    }
    
    func skip(_ offset: Int64) -> Self {
        let limit = self.limit ?? DBLimit()
        limit.offset = offset
        self.limit = limit
        return self
    }
    
    func take(_ count: Int64) -> Self {
        let limit = self.limit ?? DBLimit()
        limit.count = count
        self.limit = limit
        return self
    }
    
    func limit(_ offset: Int64 = 0, count: Int64 = 100) -> Self {
        self.limit = DBLimit(offset: offset, count: count)
        return self
    }
    
    func sql() -> String {
        var `where` = ""
        if let condition = self.condition {
            `where` = "where \(condition.sql())"
        }
        
        var orderby = ""
        if self.orderby.count > 0 {
            orderby = "order by " + self.orderby.map({ (ob) -> String in
                return ob.sql()
            }).joined(separator: ",")
        }
        
        var limit = ""
        if let condition = self.limit {
            limit = "limit \(condition.offset), \(condition.count)"
        }
        
        var columbs = "*"
        if let select = self.select {
            columbs = select.joined(separator: ",")
        }
        let sql = "select \(columbs) from `\(self.table)` \(`where`) \(orderby) \(limit)"
        return sql
    }
    
    func parameters() -> [String: DBQueryable] {
        var parameters: [String: DBQueryable] = [:]
        if let condition = self.condition {
            parameters.merge(condition.parameters()) { (v1, v2) -> DBQueryable in
                return v2
            }
        }
        return parameters
    }
    
    func build() -> (String, [String: DBQueryable]) {
        return (self.sql(), self.parameters())
    }
    
    func getRows() -> [[String: Any]] {
        var rows: [[String: Any]] = []
        let (sql, parameters) = self.build()
        NSLog("excute \(sql) with parameters: \(parameters)")
        self.connection.inDatabase({ (db) in
            if let rs = db.executeQuery(sql, withParameterDictionary: parameters) {
                while rs.next() {
                    if let map = rs.resultDictionary as? [String: Any] {
                        rows.append(map)
                    }
                }
                rs.close()
            }
        })
        return rows
    }
    
    func firstRow() -> [String: Any]? {
        var row: [String: Any]? = nil
        let (sql, parameters) = self.build()
        NSLog("excute \(sql) with parameters: \(parameters)")
        self.connection.inDatabase({ (db) in
            if let rs = db.executeQuery(sql, withParameterDictionary: parameters) {
                if rs.next() {
                    if let map = rs.resultDictionary as? [String: Any] {
                        row = map
                    }
                }
                rs.close()
            }
        })
        return row
    }
    
    @discardableResult
    func insert(_ row: [String: Any]) -> Bool {
        let filtered = row.keys.filter { (name) -> Bool in
            return name != "id"
        }
        let names = filtered.map { (name) -> String in
            return "`\(name)`"
        }
        let flags = filtered.map { (name) -> String in
            return ":\(name)"
        }
        let sql = "insert into \(self.table) (\(names.joined(separator: ","))) values (\(flags.joined(separator: ",")))"
        NSLog("excute: \(sql)")
        var isSuccess = false
        self.connection.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: row)
        }
        return isSuccess
    }
    
    @discardableResult
    func update(_ row: [String: Any], primaryKey pk: String = "id") -> Bool {
        let flags = row.keys.filter { (name) -> Bool in
            return name != pk
            }.map { (name) -> String in
                return "`\(name)` = :\(name)"
        }
        let sql = "update \(self.table) set \(flags.joined(separator: ",")) where \(pk)=:\(pk)"
        
        NSLog("excute: \(sql) values: \(row)")
        
        var isSuccess = false
        self.connection.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: row)
        }
        return isSuccess
    }
    
    @discardableResult
    func replace(_ row: [String: Any]) -> Bool {
        let names = row.keys.map { (name) -> String in
            return "`\(name)`"
        }
        let flags = row.keys.map { (name) -> String in
            return ":\(name)"
        }
        let sql = "insert or replace into \(self.table) (\(names.joined(separator: ","))) values (\(flags.joined(separator: ",")))"
        
        NSLog("excute: \(sql)")
        var isSuccess = false
        self.connection.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: row)
        }
        return isSuccess
    }
    
    @discardableResult
    func empty() -> Bool {
        let sql = "delete from \(self.table)"
        NSLog("excute: \(sql)")
        var isSuccess = false
        self.connection.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: [:])
        }
        return isSuccess
    }
    
    @discardableResult
    func delete() -> Bool {
        var `where` = ""
        if let condition = self.condition {
            `where` = "where \(condition.sql())"
        }
        let sql = "delete from \(self.table) \(`where`)"
        NSLog("excute: \(sql)")
        var isSuccess = false
        self.connection.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: [:])
        }
        return isSuccess
    }
}
