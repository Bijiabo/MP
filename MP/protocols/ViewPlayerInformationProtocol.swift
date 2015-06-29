//
//  ViewPlayerInformationProtocol.swift
//  MP
//
//  Created by bijiabo on 15/6/15.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation

@objc protocol playInformationProtocol
{
    //显示信息
    var id : String {get}
    var audioName : String {get set}
    var tag : String {get set}
    var description : String {get set}
    
    var like : Bool {get set}
    var dislike : Bool {get set}
    
    var playing : Bool {get set}
    var localUrl : String {get}
    
    var scene : String {get set}
    var scenelist : Array<String> {get}
}

@objc protocol ModelProtocol
{
    var nowPlayInfo : playInformationProtocol {get set}
}

@objc protocol PlayerViewProtocol
{
    var model : playInformationProtocol {get set}
}