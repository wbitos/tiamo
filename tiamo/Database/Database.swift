//
//  Database.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation
import FMDB

class Database: NSObject {
    static var `default` = Database()
    
    var connection: FMDatabaseQueue? =  nil
    
    func connect(path: String) {
        self.connection = FMDatabaseQueue(path: path)
    }
    
    func table(_ name: String) -> DBQuery? {
        guard let connection = self.connection else {
            return nil
        }
        let query = DBQuery(connection: connection, table: name)
        return query
    }
    
    func inDatabase(_ block: ((FMDatabase) -> Void)) {
        self.connection?.inDatabase(block)
    }
    
    func inTransaction(_ block: ((FMDatabase, UnsafeMutablePointer<ObjCBool>) -> Void)) {
        self.connection?.inTransaction(block)
    }
}
