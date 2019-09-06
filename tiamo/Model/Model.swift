//
//  Model.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import ObjectMapper
import FMDB

class Model: NSObject, Mappable {
    var id: Int64 = 0
    var db: Database? = nil
    
    required init?(map: Map) {
        id = (try? map.value("id")) ?? 0
        super.init()
    }
    
    func mapping(map: Map) {
        id <- map["id"]
    }
    
    init(db: Database? = nil) {
        self.db = db
        super.init()
    }
}
