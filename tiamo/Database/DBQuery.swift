//
//  DBQuery.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation
import FMDB
import ObjectMapper

open class DBQuery: NSObject {
    open var table: String
    open var database: Database

    private var condition: DBCondition?
    private var orderby: [DBOrderby] = []
    private var limit: DBLimit?
    private var select: [String]? = nil

    public init(database: Database, table: String) {
        self.database = database
        self.table = table
        super.init()
    }

    open func select(_ columbs: [String]? = nil) -> Self {
        self.select = columbs
        return self
    }
    
    open func `where`(_ key: String, `operator`: DBValueCondition.Operator = .equal, value: DBQueryable) -> Self {
        self.condition = DBValueCondition(key: key, value: value, operator: `operator`)
        return self
    }
    
    open func orWhere(_ key: String, `operator`: DBValueCondition.Operator = .equal, value: DBQueryable) -> Self {
        guard let prev = self.condition else {
            return self
        }
        
        let current = DBValueCondition(key: key, value: value, operator: `operator`)
        self.condition = DBCombinationCondition(conditions: [prev, current], operator: .or)
        return self
    }
    
    open func andWhere(_ key: String, `operator`: DBValueCondition.Operator = .equal, value: DBQueryable) -> Self {
        guard let prev = self.condition else {
            return self
        }
        
        let current = DBValueCondition(key: key, value: value, operator: `operator`)
        self.condition = DBCombinationCondition(conditions: [prev, current], operator: .and)
        return self
    }
    
    open func orderby(_ key: String, order: DBOrderby.Order) -> Self {
        let orderby = DBOrderby(key, order: order)
        self.orderby.append(orderby)
        return self
    }
    
    open func skip(_ offset: Int64) -> Self {
        let limit = self.limit ?? DBLimit()
        limit.offset = offset
        self.limit = limit
        return self
    }
    
    open func take(_ count: Int64) -> Self {
        let limit = self.limit ?? DBLimit()
        limit.count = count
        self.limit = limit
        return self
    }
    
    open func limit(_ offset: Int64 = 0, count: Int64 = 100) -> Self {
        self.limit = DBLimit(offset: offset, count: count)
        return self
    }
    
    public func sql() -> String {
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
    
    public func parameters() -> [String: DBQueryable] {
        var parameters: [String: DBQueryable] = [:]
        if let condition = self.condition {
            parameters.merge(condition.parameters()) { (v1, v2) -> DBQueryable in
                return v2
            }
        }
        return parameters
    }
    
    open func build() -> (String, [String: DBQueryable]) {
        return (self.sql(), self.parameters())
    }
    
    open func getRows() -> [[String: Any]] {
        var rows: [[String: Any]] = []
        let (sql, parameters) = self.build()
        NSLog("excute \(sql) with parameters: \(parameters)")
        self.database.inDatabase({ (db) in
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
    
    open func firstRow() -> [String: Any]? {
        var row: [String: Any]? = nil
        let (sql, parameters) = self.build()
        NSLog("excute \(sql) with parameters: \(parameters)")
        self.database.inDatabase({ (db) in
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
    
    open func findRow(_ id: Int64) -> [String: Any]? {
        return self.where("id", value: id).firstRow()
    }
    
    func get<T: Mappable>() -> [T] {
        return self.getRows().map({ (json) -> T in
            return T(JSON: json)!
        })
    }
    
    func first<T: Mappable>() -> T? {
        guard let json = self.firstRow() else {
            return nil
        }
        return T(JSON: json)
    }
    
    open func find<T: Mappable>(_ id: Int64) -> T? {
        guard let json = self.findRow(id) else {
            return nil
        }
        return T(JSON: json)
    }
    
    @discardableResult
    open func insert(_ row: [String: Any]) -> Bool {
        let filtered = row.filter { (arg0) -> Bool in
            let (key, _) = arg0
            return key != "id"
        }
        
        let names = filtered.map { (arg0) -> String in
            let (name, _) = arg0
            return "`\(name)`"
        }
        let flags = filtered.map { (arg0) -> String in
            let (name, _) = arg0
            return ":\(name)"
        }
        let sql = "insert into `\(self.table)` (\(names.joined(separator: ","))) values (\(flags.joined(separator: ",")))"
        NSLog("excute: \(sql)")
        var isSuccess = false
        self.database.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: filtered)
        }
        return isSuccess
    }
    
    @discardableResult
    open func update(_ row: [String: Any], primaryKey pk: String = "id") -> Bool {
        let flags = row.keys.filter { (name) -> Bool in
            return name != pk
            }.map { (name) -> String in
                return "`\(name)` = :\(name)"
        }
        let sql = "update `\(self.table)` set \(flags.joined(separator: ",")) where \(pk)=:\(pk)"
        
        NSLog("excute: \(sql) values: \(row)")
        
        var isSuccess = false
        self.database.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: row)
        }
        return isSuccess
    }
    
    @discardableResult
    open func replace(_ row: [String: Any]) -> Bool {
        let names = row.keys.map { (name) -> String in
            return "`\(name)`"
        }
        let flags = row.keys.map { (name) -> String in
            return ":\(name)"
        }
        let sql = "insert or replace into `\(self.table)` (\(names.joined(separator: ","))) values (\(flags.joined(separator: ",")))"
        
        NSLog("excute: \(sql)")
        var isSuccess = false
        self.database.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: row)
        }
        return isSuccess
    }
    
    @discardableResult
    open func empty() -> Bool {
        let sql = "delete from `\(self.table)`"
        NSLog("excute: \(sql)")
        var isSuccess = false
        self.database.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: [:])
        }
        return isSuccess
    }
    
    @discardableResult
    open func delete() -> Bool {
        var `where` = ""
        if let condition = self.condition {
            `where` = "where \(condition.sql())"
        }
        let sql = "delete from `\(self.table)` \(`where`)"
        NSLog("excute: \(sql)")
        var isSuccess = false
        self.database.inTransaction { (db, rollback) in
            isSuccess = db.executeUpdate(sql, withParameterDictionary: [:])
        }
        return isSuccess
    }
    
    public typealias DBQueryBuildBlock = ((DBQuery) -> Void)
    
    private var withs: [DBTable: DBQueryBuildBlock] = [:]
    
    open func with(table: DBTable, query: DBQueryBuildBlock? = nil) -> Self {
        let empty: DBQueryBuildBlock = {(query) -> Void in
            
        }
        self.withs[table] = query ?? empty
        return self
    }
    
    open func with(subQueries: [DBTable: DBQueryBuildBlock]) -> Self {
        self.withs.merge(subQueries) { (b1, b2) -> DBQuery.DBQueryBuildBlock in
            return b2
        }
        return self
    }
}
