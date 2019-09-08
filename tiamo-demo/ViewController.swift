//
//  ViewController.swift
//  tiamo-demo
//
//  Created by wbitos on 2019/9/6.
//  Copyright © 2019 when. All rights reserved.
//

import UIKit
import Tiamo

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        if let dbPath = try? FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("tiamo.sqlite3").path {
            
            NSLog("db path: \(dbPath)")
            
            let db = Database()
            db.connect(path: dbPath)
            
            //DBTable(model: Calendar.self).create(database: db)
            
            let calendar = Calendar(db: db)
            calendar.name = "我的日历"
            calendar.desc = "我的个人日历，私有日历"
            calendar.save()
            
            NSLog("\(calendar.columns().toJSON())")
        }
    }


}

