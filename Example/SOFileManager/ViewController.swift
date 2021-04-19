//
//  ViewController.swift
//  SOFileManager
//
//  Created by AliliWVIP on 04/15/2021.
//  Copyright (c) 2021 AliliWVIP. All rights reserved.
//

import UIKit
import SOFileManager
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        SOFileManager.asyncSaveData(data: Data(), path: SOFileManager.getDirectory(directoryType: .documents)) { (success) in
            if success {
                print("success")
            }else{
                print("failure")
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

