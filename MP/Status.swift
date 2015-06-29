//
//  State.swift
//  MP
//
//  Created by bijiabo on 15/6/18.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation

class Status : StatusProtocol
{
    var indexData : Dictionary<String,AnyObject> = Dictionary<String,AnyObject> ()
    
    func setIndex(sceneName : String , index : Int)
    {
        
    }
    
    func getIndex(sceneName : String) -> Int
    {
        return 0
    }
    
    init()
    {
        
    }
}