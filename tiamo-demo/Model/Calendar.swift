//
//  Calendar.swift
//  tiamo-demo
//
//  Created by suyu on 2019/9/8.
//  Copyright © 2019 wbitos. All rights reserved.
//

import UIKit
import Tiamo
import ObjectMapper

class Calendar: Model, Record, SoftDeletes {
    @objc var deletedAt: Date? = nil
    @objc var createdAt: Date = Date()
    @objc var updatedAt: Date = Date()
    
    @objc var name: String = "another calendar"
    @objc var desc: String = "description for calendar"
    @objc var userId: Int64 = 0
    
    var tags: [CalendarTag] = []
    
    override init(db: Database) {
        super.init(db: db)
    }
    
    public required init?(map: Map) {
        super.init(map: map)
        name = (try? map.value("name")) ?? ""
        desc = (try? map.value("desc")) ?? ""
        userId = (try? map.value("userId")) ?? 0
        
        createdAt = (try? map.value("createdAt", using: DateTransform())) ?? Date()
        updatedAt = (try? map.value("updatedAt", using: DateTransform())) ?? Date()
        deletedAt = try? map.value("deletedAt", using: DateTransform())
    }
    
    override func mapping(map: Map) {
        super.mapping(map: map)
        name <- map["name"]
        desc <- map["desc"]
        userId <- map["userId"]
        
        createdAt <- (map["createdAt"], DateTransform(unit: .milliseconds))
        updatedAt <- (map["updatedAt"], DateTransform(unit: .milliseconds))
        deletedAt <- (map["deletedAt"], DateTransform(unit: .milliseconds))
    }
}
