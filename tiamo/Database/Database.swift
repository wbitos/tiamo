//
//  Database.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import FMDB

class Database: NSObject {
    var connection: FMDatabaseQueue? =  nil
    
    init(path: String) {
        self.connection = FMDatabaseQueue(path: path)
        super.init()
    }
    
    func table(_ name: String) -> DBQuery? {
        guard let connection = self.connection else {
            return nil
        }
        let query = DBQuery(connection: connection, table: name)
        return query
    }
    
    
}
