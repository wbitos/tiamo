//
//  SoftDeletes.swift
//  tiamo
//
//  Created by suyu on 2019/9/7.
//  Copyright © 2019 wbitos. All rights reserved.
//

import Foundation

protocol SoftDeletes {
    var deletedAt: Date? { get set }
}
