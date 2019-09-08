//
//  Property.swift
//  tiamo-demo
//
//  Created by suyu on 2019/9/8.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation
import ObjectMapper

let DatabaseValueTypesMap: [String: String] = [
    "Int8"     : "INTEGER",
    "Int16"    : "INTEGER",
    "Int32"    : "INTEGER",
    "Int64"    : "INTEGER",
    "Int"      : "INTEGER",
    "UInt16"   : "INTEGER",
    "UInt32"   : "INTEGER",
    "UInt64"   : "INTEGER",
    "UInt"     : "INTEGER",
    "Bool"     : "INTEGER",
    "NSInteger": "INTEGER",
    "Double"   : "REAL",
    "Float"    : "REAL",
    "Decimal"  : "REAL",
    "NSNumber" : "REAL",
    "NSDate"   : "INTEGER",
    "NSString" : "TEXT",
]

open class Property: NSObject, Mappable {
    public required init?(map: Map) {
        self.name = (try? map.value("name")) ?? "unkown"
        self.type = (try? map.value("type")) ?? "Int"
        super.init()
    }
    
    public func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
    }
    
    open var name: String
    open var type: String
    
    public init(name: String, type: String) {
        self.name = name
        self.type = type
        super.init()
    }
    
    open func databaseValueType() -> String {
        return DatabaseValueTypesMap[self.type] ?? ""
    }
}
