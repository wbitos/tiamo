//
//  Database.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation
import FMDB

open class Database: NSObject {
    public static var `default` = Database()
    
    public override init() {
        super.init()
    }
    
    private var connection: FMDatabaseQueue? =  nil
    
    open func connect(path: String) {
        self.connection = FMDatabaseQueue(path: path)
    }
    
    open func table(_ name: String) -> DBQuery? {
        let query = DBQuery(database: self, table: name)
        return query
    }
    
    open func inDatabase(_ block: ((FMDatabase) -> Void)) {
        self.connection?.inDatabase(block)
    }
    
    open func inTransaction(_ block: ((FMDatabase, UnsafeMutablePointer<ObjCBool>) -> Void)) {
        self.connection?.inTransaction(block)
    }
    
    
}
