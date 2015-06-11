//
//  playlistViewController.swift
//  MP
//
//  Created by bijiabo on 15/6/12.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit

class playlistViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableview: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()


    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : playlistTableViewCell = tableview.dequeueReusableCellWithIdentifier("playlistCell", forIndexPath: indexPath) as! playlistTableViewCell
        
        cell.title.text = "音频名称"
        cell.descriptionLabel.text = "来自廖彩杏书单"
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section
        {
        case 0:
            return "孩子喜欢的"
            
        case 1:
            return "为您的孩子推荐的"
            
        case 2:
            return "孩子不喜欢的"
            
        default:
            return ""
        }
    }
    
    @IBAction func tapSaveButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}
