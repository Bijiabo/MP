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
            
            let playContent = server.currentPlayContent()
            
            let cachePath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as! String
            
            let playFileName : String = playContent["url"] as! String
            
            let playURL : NSURL = NSURL(fileURLWithPath: "\(cachePath)/media/\(playFileName)")!
            
            let player : AVAudioPlayer = AVAudioPlayer(contentsOfURL: playURL, error: nil)
            
        }
    }
    
    
    //test mainViewController
    /*
    func testInitTabBar()
    {
        let tabbar : UITabBar = UITabBar()
        
        let vc : mainViewController = mainViewController()
        vc.server = Server()
        
        vc._refreshTabBar(tabbar: tabbar, scenelist: ["午后","睡前","玩耍","起床"], currentScene: "玩耍")
        
        
        XCTAssert(tabbar.items?.count > 0  , "mainViewController tabBar init func Pass.")
    }
    */
}
