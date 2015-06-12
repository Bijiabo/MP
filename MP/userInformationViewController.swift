//
//  userInformationViewController.swift
//  MP
//
//  Created by bijiabo on 15/6/12.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit

class userInformationViewController: UIViewController {

    @IBOutlet var childNameTextField: UITextField!
    @IBOutlet var childSexualitySegmentedControl: UISegmentedControl!
    @IBOutlet var childBirthdayDatePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func initView () -> Void
    {
        initDatePicker()
        
        if let childName =  NSUserDefaults.standardUserDefaults().stringForKey("childName")
        {
            childNameTextField.text = childName
        }
        
        if let childSexuality = NSUserDefaults.standardUserDefaults().stringForKey("childSexuality")
        {
            for var i = 0 ; i < childSexualitySegmentedControl.numberOfSegments ; i++
            {
                if childSexualitySegmentedControl.titleForSegmentAtIndex(i) == childSexuality
                {
                    childSexualitySegmentedControl.selectedSegmentIndex = i
                    break
                }
            }
        }
        
    }
    
    func initDatePicker () -> Void
    {
        let ageMax : Int = 4
        let minimumDate : NSDate = NSDate(timeIntervalSinceNow: NSTimeInterval( -3600*24*365*(ageMax+1) + 3600*24*1 ))
        childBirthdayDatePicker.minimumDate = minimumDate
        childBirthdayDatePicker.maximumDate = NSDate()
        
        if let childBirthday: AnyObject = NSUserDefaults.standardUserDefaults().objectForKey("childBirthday")
        {
            childBirthdayDatePicker.date = childBirthday as! NSDate
        }
    }
    

    @IBAction func tapSaveButton(sender: UIBarButtonItem) {
        
        NSUserDefaults.standardUserDefaults().setObject(childNameTextField.text, forKey: "childName")
        
        let childSexuality : String =  childSexualitySegmentedControl.titleForSegmentAtIndex(childSexualitySegmentedControl.selectedSegmentIndex)!
        NSUserDefaults.standardUserDefaults().setObject(childSexuality, forKey: "childSexuality")
        
        NSUserDefaults.standardUserDefaults().setObject(childBirthdayDatePicker.date, forKey: "childBirthday")
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func tapCancelButton(sender: UIBarButtonItem) {
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    

}
