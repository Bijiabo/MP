//
//  dataLoader.swift
//  MP
//
//  Created by bijiabo on 15/6/4.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation

class dataLoader {
    var data : JSON!
    
    init ()
    {
        data = JSON([])
    }
    
    init (dataFileName : String , pathInBundle : String)
    {
        let path = "\(pathInBundle)/\(dataFileName)"
        
        let dataFileURL : NSURL = NSBundle.mainBundle().resourceURL!.URLByAppendingPathComponent(path, isDirectory: false)
        
        let dataFileData : NSData = NSData(contentsOfURL: dataFileURL)!
        
        data = JSON(data : dataFileData)
    }
    
}