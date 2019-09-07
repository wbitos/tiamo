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

typealias PropertyName = String

class Model: NSObject, Mappable {
    var id: Int64 = 0
    
    var table: String = "\(type(of: self))"
    
    lazy var db: Database = {
        return Database.`default`
    }()
    
    required init?(map: Map) {
        id = (try? map.value("id")) ?? 0
        super.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
    }
    
    init(db: Database) {
        super.init()
        self.db = db
    }
    
    @discardableResult
    func insert() -> Bool {
        return self.db.table(self.table)?.insert(self.toJSON()) ?? false
    }
    
    @discardableResult
    func update() -> Bool {
        return self.db.table(self.table)?.update(self.toJSON()) ?? false
    }
    
    @discardableResult
    func replace() -> Bool {
        return self.db.table(self.table)?.replace(self.toJSON()) ?? false
    }
    
    @discardableResult
    func save() -> Bool {
        return (self.id > 0) ? self.replace() : self.insert()
    }
    
    func empty() -> Bool {
        return self.db.table(self.table)?.empty() ?? true
    }
    
    // FIXME: excepts
    static var excepts: [PropertyName] = {
        return  ["db", "table", "except"]
    }()
    
    func columbs() -> [String] {
        return self.properties(true).filter({ (name) -> Bool in
            return type(of: self).excepts.contains(name)
        })
    }
    
    class func columbs() -> [String] {
        return self.properties(true).filter({ (name) -> Bool in
            return !self.excepts.contains(name)
        })
    }
    
    func properties(_ deep: Bool) -> [PropertyName] {
        return Model.properties(forClass: self.classForCoder, deep: deep)
    }
    
    class func properties(forClass aClass: AnyClass, deep: Bool) -> [PropertyName] {
        var properties:[String] = []
        var cls: AnyClass = aClass
        repeat {
            var count: UInt32 = 0
            if let list = class_copyPropertyList(cls, &count) {
                for i in 0..<count {
                    let cname = property_getName(list[Int(i)])
                    if let name = String(cString: cname, encoding: String.Encoding.utf8) {
                        properties.append(name)
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
    
    class func properties(_ deep: Bool) -> [PropertyName] {
        return Model.properties(forClass: self.classForCoder(), deep: deep)
    }
}
