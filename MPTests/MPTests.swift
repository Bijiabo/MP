//
//  MPTests.swift
//  MPTests
//
//  Created by JGTM on 15/6/1.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit
import XCTest
import AVFoundation
import AVKit
import MediaPlayer

class MPTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    //[class]Server test
    
    func testNextPlayContent()
    {
        let server = Server()
        let nextPlayContent = server.nextPlayConent()
        
        XCTAssert(nextPlayContent.count == 3, "nextPlayContent Pass")
    }
    
    func testPrevPlayContent()
    {
        let server = Server()
        let nextPlayContent = server.prevPlayContent()
        
        XCTAssert(nextPlayContent.count == 3, "nextPlayContent Pass")
    }
    
    func testGetScenelist()
    {
        let server = Server()
        let scenelist = server.sceneList()
        
        XCTAssert(scenelist.count == 4, "get scenelist Pass")
    }
    
    
    
    
    func testAppStartPerformance() {
        // This is an example of a performance test case.
        self.measureBlock() {
            
            let server = Server()
            let player : AVAudioPlayer!
            
            let playContent = server.currentPlayContent()
            
            let cachePath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as! String
            
            let playFileName : String = playContent["url"]!
            let playURL : NSURL = NSURL(fileURLWithPath: "\(cachePath)/resource/media/\(playFileName)")!
            
            //若音频文件不存在，则切换至下一首
            if NSFileManager.defaultManager().fileExistsAtPath(playURL.relativePath!) == false
            {
                server.currentIndexOfScene++
                return
            }
            
            var error : NSError?
            
            player = audioPlayer(contentsOfURL: playURL, error: &error)
            
            player.prepareToPlay()
        }
    }
    
    
    //test mainViewController

    func testInitTabBar()
    {
        let tabbar : UITabBar = UITabBar()
        
        var model : Dictionary<String,AnyObject> = Server().currentPlayContent()
        model["playing"] = false
        model["currentScene"] = 0
        model["scenelist"] = ["午后","睡前","玩耍","起床"]
        
        let vc : mainViewController = mainViewController()
        vc.tabBar = tabbar
        vc.model = model
        
        vc._refreshTabBar(tabbar: tabbar, scenelist: ["午后","睡前","玩耍","起床"], currentScene: "玩耍")
        
        XCTAssert(tabbar.items?.count == 4  , "mainViewController tabBar init func Pass.")
    }

    //测试 MPRemoteCommandCenter 再放一遍
    func testMPRemoteCommandCenter_playOnceAgain()
    {
        let delegate : AppDelegate = AppDelegate()
        delegate.server = Server()
        delegate.server.delegate = delegate
        
        let remoteCommandCenter : RemoteCommandCenter = RemoteCommandCenter()
        remoteCommandCenter.delegate = delegate
        remoteCommandCenter.initMPRemoteCommandCenter()
        
        remoteCommandCenter.triggerPlayAgainCommand(true)
        let successForPlayAgain : Bool =  delegate.server.playOnceAgain==true && MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.localizedTitle == "🎵 取消再放一遍"
        
        remoteCommandCenter.triggerPlayAgainCommand(false)
        let successForCancelPlayAgain : Bool =  delegate.server.playOnceAgain==false && MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.localizedTitle == "🎵 再放一遍"
        
        XCTAssert(successForPlayAgain && successForCancelPlayAgain   , "mainViewController tabBar init func Pass.")
    }
    
}
