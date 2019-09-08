//
//  DBTable.swift
//  Tiamo
//
//  Created by suyu on 2019/9/8.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

open class DBTable: NSObject {
    open var name: String

    private var database: Database? = nil
    private var columns: [DBColumn] = []
    
    public init(name: String) {
        self.name = name
        super.init()
    }
    
    public init(model: Model.Type) {
        self.name = "\(type(of: model))"
        super.init()
    }
    
    open func creation() -> String {
        return "create table \(self.name) (" + self.columns.map({ (column) -> String in
            return "\(column.name) \(column.type)" + (column.primary ? " primary key" : "") + (column.auto ? " autoincrement" : "") + (column.nullable ? "" : " not null")
        }).joined(separator: ",") + ")"
    }
    
    open func create() -> Bool {
        return true
    }
    
    
}
