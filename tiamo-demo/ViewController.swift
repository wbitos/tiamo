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
        if let dbPath = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.chihuahua.fanli")?.appendingPathComponent("tiamo.sqlite3").path {
            
            let db = Database()
            db.connect(path: dbPath)
            
            
        }
    }


}

