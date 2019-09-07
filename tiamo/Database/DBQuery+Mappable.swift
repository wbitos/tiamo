//
//  DBQuery+Mappable.swift
//  tiamo
//
//  Created by suyu on 2019/9/7.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation
import ObjectMapper

public extension DBQuery {
    func get<T: Mappable>() -> [T] {
        return self.getRows().map({ (json) -> T in
            return T(JSON: json)!
        })
    }
    
    func first<T: Mappable>() -> T? {
        guard let json = self.firstRow() else {
            return nil
        }
        return T(JSON: json)
    }
}
