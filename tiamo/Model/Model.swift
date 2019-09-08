//
//  Model.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation
import ObjectMapper
import FMDB

let PropertyAbbreviationTypesMap: [String: String] = [
    "c" : "Int8",
    "s" : "Int16",
    "i" : "Int32",
    "q" : "Int", //also: Int64, NSInteger, only true on 64 bit platforms
    "S" : "UInt16",
    "I" : "UInt32",
    "Q" : "UInt", //also UInt64, only true on 64 bit platforms
    "B" : "Bool",
    "d" : "Double",
    "f" : "Float",
    "{" : "Decimal"
]

open class Model: NSObject, Mappable {
    @objc open var id: Int64 = 0
    
    open class func table() -> DBTable {
        return DBTable(model: self)
    }
    
    open lazy var db: Database = {
        return Database.`default`
    }()
    
    required public init?(map: Map) {
        id = (try? map.value("id")) ?? 0
        super.init()
    }
    
    open func mapping(map: Map) {
        id <- map["id"]
    }
    
    public init(db: Database) {
        super.init()
        self.db = db
    }
    
    @discardableResult
    open func insert() -> Bool {
        return self.db.table(type(of: self).table().name)?.insert(self.toJSON()) ?? false
    }
    
    @discardableResult
    open func update() -> Bool {
        return self.db.table(type(of: self).table().name)?.update(self.toJSON()) ?? false
    }
    
    @discardableResult
    open func replace() -> Bool {
        return self.db.table(type(of: self).table().name)?.replace(self.toJSON()) ?? false
    }
    
    @discardableResult
    open func save() -> Bool {
        return (self.id > 0) ? self.replace() : self.insert()
    }
    
    open func empty() -> Bool {
        return self.db.table(type(of: self).table().name)?.empty() ?? true
    }
    
    // FIXME: excepts
    public static var excepts: [String] = {
        return  ["db", "table", "except"]
    }()
    
    open func columns() -> [DBColumn] {
        return self.properties(true).filter({ (p) -> Bool in
            return !type(of: self).excepts.contains(p.name)
        }).map({ (p) -> DBColumn in
            let column = DBColumn(name: p.name, type: DBColumn.ValueType(rawValue: p.databaseValueType()) ?? .auto)
            if p.name == "id" {
                column.primary = true
                column.auto = true
                column.nullable = false
            }
            return column
        })
    }
    
    open class func columns() -> [DBColumn] {
        return self.properties(true).filter({ (p) -> Bool in
            return !self.excepts.contains(p.name)
        }).map({ (p) -> DBColumn in
            let column = DBColumn(name: p.name, type: DBColumn.ValueType(rawValue: p.databaseValueType()) ?? .auto)
            if p.name == "id" {
                column.primary = true
                column.auto = true
                column.nullable = false
            }
            return column
        })
    }
    
    open func properties(_ deep: Bool) -> [Property] {
        return Model.properties(forClass: self.classForCoder, deep: deep)
    }
    
    private class func properties(forClass aClass: AnyClass, deep: Bool) -> [Property] {
        var properties:[Property] = []
        var cls: AnyClass = aClass
        repeat {
            var count: UInt32 = 0
            if let list = class_copyPropertyList(cls, &count) {
                for i in 0..<count {
                    let property = list[Int(i)]
                    let cname = property_getName(property)
                    guard let name = String(cString: cname, encoding: String.Encoding.utf8) else {
                        continue
                    }
                    
                    guard let cattributes = property_getAttributes(property) else {
                        continue
                    }
                    
                    guard let attributes = String(cString: cattributes, encoding: String.Encoding.utf8) else {
                        continue
                    }
                    
                    let slices = attributes.components(separatedBy: "\"")
                    
                    if slices.count > 1 {
                        let type = slices[1]
                        let p = Property(name: name, type: type)
                        properties.append(p)
                    }
                    else {
                        let letter = attributes[attributes.index(attributes.startIndex, offsetBy: 1)..<attributes.index(attributes.startIndex, offsetBy: 2)]
                        if let type = PropertyAbbreviationTypesMap["\(letter)"] {
                            let p = Property(name: name, type: type)
                            properties.append(p)
                        }
                    }
                }
                free(list)
            }
            if let su = cls.superclass() {
                cls = su
                if cls == NSObject.classForCoder() {
                    break
                }
            }
            else {
                break
            }
        } while(deep)
        return properties
    }
    
    open class func properties(_ deep: Bool) -> [Property] {
        return Model.properties(forClass: self.classForCoder(), deep: deep)
    }
}
