//
//  userInformationViewController.swift
//  MP
//
//  Created by bijiabo on 15/6/12.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit

class userInformationViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    

    @IBAction func tapSaveButton(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapCancelButton(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
