//
//  NoAccountViewController.swift
//  Eloquence
//
//  Created by Frieder Reinhold on 18.02.16.
//  Copyright © 2016 TRIGONmedia. All rights reserved.
//

import Cocoa

class NoAccountViewController: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    @IBAction func addAccountClicked(sender: AnyObject) {
        AppScope.instance.openPreferences();
    }
}
