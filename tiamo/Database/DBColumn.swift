//
//  DBColumn.swift
//  Tiamo
//
//  Created by suyu on 2019/9/8.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation
import ObjectMapper

open class DBColumn: NSObject, Mappable {
    public enum ValueType: String {
        case integer = "INTEGER"
        case text = "TEXT"
        case real = "REAL"
        case auto = ""
    }
    
    open var name: String
    open var type: ValueType
    open var primary: Bool = false
    open var auto: Bool = false
    open var nullable: Bool = true
    
    public required init?(map: Map) {
        self.name = (try? map.value("name")) ?? "unkown"
        self.type = ValueType(rawValue: (try? map.value("type")) ?? "") ?? .auto
        super.init()
    }
    
    public func mapping(map: Map) {
        name <- map["name"]
        type <- map["type"]
    }
        
    public init(name: String, type: ValueType, primary: Bool = false, auto: Bool = false, nullable: Bool = true) {
        self.name = name
        self.type = type
        self.primary = primary
        self.auto = auto
        self.nullable = nullable
        super.init()
    }
    
    private var table: DBTable? = nil

    open var hasOne: (DBTable, DBColumn)? = nil
    open var hasMany: (DBTable, DBColumn)? = nil
    open var belongOne: (DBTable, DBColumn)? = nil
    open var belongMany: (DBTable, DBColumn)? = nil
}
