//
//  ViewPlayerActionProtocol.swift
//  MP
//
//  Created by bijiabo on 15/6/15.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation

protocol playerProtocol
{
    //基础属性
    var bePlaying: Bool { get }
    
    //切换播放状态
    func play() -> Bool
    func pause()
    func togglePlayOrPause()
    
    //再放一遍
    func playOnceAgain()
}

@objc protocol playerDelegate
{
    //    func playerDidFinishPlaying()
    func play()
    func pause()
    func togglePlayOrPause()
}

@objc protocol loveActionProtocol
{
    //喜好反馈
    func doLike()
    func doDislike()
}

@objc protocol sceneProtocol
{
    //切换场景
    func switchScene(targetScene : String)
    
}

