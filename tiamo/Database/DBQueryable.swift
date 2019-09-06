//
//  DBQueryable.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit

protocol DBQueryable {
    func sqlValue() -> String
}

class Interval<T: DBQueryable>: NSObject, DBQueryable {
    var left: T
    var right: T
    
    init(left: T, right: T) {
        self.left = left
        self.right = right
        super.init()
    }
    
    func sqlValue() -> String {
        return "\(self.left.sqlValue()) and \(self.right.sqlValue())"
    }
}

typealias IntegerInterval = Interval<Int>
typealias Int64Interval = Interval<Int64>
typealias StringInterval = Interval<String>

typealias MultValue = [DBQueryable]

extension MultValue: DBQueryable {
    func sqlValue() -> String {
        let sqlValue = self.map { (queryable) -> String in
            return queryable.sqlValue()
        }.joined(separator: ",")
        return "(\(sqlValue))"
    }
}

extension String: DBQueryable {
    func sqlValue() -> String {
        return "\(self)"
    }
}

extension Int: DBQueryable {
    func sqlValue() -> String {
        return "\(self)"
    }
}

extension Int64: DBQueryable {
    func sqlValue() -> String {
        return "\(self)"
    }
}

extension Date: DBQueryable {
    func sqlValue() -> String {
        return "\(self)"
    }
}

extension Bool: DBQueryable {
    func sqlValue() -> String {
        return "\(self)"
    }
}
