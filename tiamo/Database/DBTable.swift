//
//  DBTable.swift
//  Tiamo
//
//  Created by suyu on 2019/9/8.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

open class DBTable: NSObject {
    open var name: String

    private var database: Database? = nil
    private var columns: [DBColumn] = []
    
    public init(name: String, database: Database? = nil) {
        self.name = name
        self.database = database
        super.init()
    }
    
    public init(model: Model.Type, database: Database? = nil) {
        self.name = String(describing: model.classForCoder()) //"\(type(of: model))"
        self.columns = model.columns()
        self.database = database
        super.init()
    }
    
    open func creation() -> String {
        return "create table \(self.name) (" + self.columns.map({ (column) -> String in
            return "\(column.name)" + ((column.type == .auto) ? "" : " \(column.type.rawValue)") + (column.primary ? " primary key" : "") + (column.auto ? " autoincrement" : "") + (column.nullable ? "" : " not null")
        }).joined(separator: ",") + ")"
    }
    
    @discardableResult
    open func create(database: Database? = nil) -> Bool {
        var isSuccess: Bool = false
        (database ?? self.database)?.inDatabase({ (db) in
            isSuccess = db.executeUpdate(self.creation(), withArgumentsIn: [])
        })
        return isSuccess
    }
}
