//
//  File.swift
//  MP
//
//  Created by bijiabo on 15/6/18.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation

protocol ServerProtocol
{
    var playlist : [Dictionary<String,AnyObject>] {get}
    var scenelist : Array<String> {get}
    var playInfo : playInformationProtocol {get}
    
    var currentScene : String {get}
    
    func switchToScene(targetScene : String)
    
    func next()
    func previous()
}

protocol StatusProtocol
{
    var indexData : Dictionary<String,AnyObject> {get}
    
    func setIndex(sceneName : String , index : Int)
    
    func getIndex(sceneName : String)->Int
}