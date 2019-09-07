//
//  DBQueryable.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

public protocol DBQueryable {
    func sqlValue() -> String
}

public class Interval<T: DBQueryable>: NSObject, DBQueryable {
    var left: T
    var right: T
    
    init(left: T, right: T) {
        self.left = left
        self.right = right
        super.init()
    }
    
    public func sqlValue() -> String {
        return "\(self.left.sqlValue()) and \(self.right.sqlValue())"
    }
}

public typealias IntegerInterval = Interval<Int>
public typealias Int64Interval = Interval<Int64>
public typealias StringInterval = Interval<String>

public typealias MultValue = [DBQueryable]

extension MultValue: DBQueryable {
    public func sqlValue() -> String {
        let sqlValue = self.map { (queryable) -> String in
            return queryable.sqlValue()
        }.joined(separator: ",")
        return "(\(sqlValue))"
    }
}

extension String: DBQueryable {
    public func sqlValue() -> String {
        return "\(self)"
    }
}

extension Int: DBQueryable {
    public func sqlValue() -> String {
        return "\(self)"
    }
}

extension Int64: DBQueryable {
    public func sqlValue() -> String {
        return "\(self)"
    }
}

extension Date: DBQueryable {
    public func sqlValue() -> String {
        return "\(self)"
    }
}

extension Bool: DBQueryable {
    public func sqlValue() -> String {
        return "\(self)"
    }
}
