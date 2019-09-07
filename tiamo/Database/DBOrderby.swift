//
//  DBOrderby.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

class DBOrderby: NSObject {
    enum Order: String {
        case asc = "asc"
        case desc = "desc"
    }
    
    var by: String
    var order: DBOrderby.Order = .asc
    
    init(_ by: String, order: DBOrderby.Order = .asc) {
        self.by = by
        self.order = order
        super.init()
    }
    
    func sql() -> String {
        let sql = "\(self.by) \(self.order.rawValue)"
        return sql
    }
}
