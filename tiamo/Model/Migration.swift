//
//  Migration.swift
//  tiamo
//
//  Created by suyu on 2019/9/7.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

public class Migration: Model {
    var createdAt: Date = Date()
    var model: String? = nil
    var sql: String? = nil
}
