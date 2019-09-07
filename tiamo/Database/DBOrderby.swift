//
//  DBOrderby.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

open class DBOrderby: NSObject {
    public enum Order: String {
        case asc = "asc"
        case desc = "desc"
    }
    
    open var by: String
    open var order: DBOrderby.Order = .asc
    
    public init(_ by: String, order: DBOrderby.Order = .asc) {
        self.by = by
        self.order = order
        super.init()
    }
    
    open func sql() -> String {
        let sql = "\(self.by) \(self.order.rawValue)"
        return sql
    }
}
