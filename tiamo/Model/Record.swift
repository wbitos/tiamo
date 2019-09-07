//
//  Record.swift
//  tiamo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

public protocol Record {
    var createdAt: Date { get set }
    var updatedAt: Date { get set }
}
