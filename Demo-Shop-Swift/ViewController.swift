//
//  ViewController.swift
//  Demo-Shop-Swift
//
//  Created by MobCast Innovations on 06/03/18.
//  Copyright © 2018 MobCast Innovations. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func btnTestClick(_ sender: UIButton) {
        self.apiTest()
    }
    func apiTest() {
        ATAppManager.sharedManager().refreshDemoData()
    }
}

