//
//  AppDelegate.swift
//  MP
//
//  Created by JGTM on 15/6/1.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate , AVAudioPlayerDelegate , loveActionProtocol,sceneProtocol , playerDelegate

{
    var window: UIWindow?
    
    var player : playerProtocol!
    var server : Server!
    var networkServer : NetworkService!
    
    var nowPlayingCenterController: NowPlayingInfoCenterController!
    
    var stateAvtive : Bool = true
    var userHadViewSettings : Bool = false
    
    var nowPlayInfo : playInformationProtocol!
    
    //MARK:
    //MARK: 📍  init functions

    func initServer () -> Void
    {
        //set local server
        server = Server()
    }
    
    func initRootViewController() -> Void
    {
        //set root VC
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainVC") as! UIViewController
        
        
        if vc.conformsToProtocol(PlayerViewProtocol)
        {
            (vc as! PlayerViewProtocol).model = self.nowPlayInfo
        }

    }

    func initRemoteCommandCenter() -> Void
    {
        //set MPRemoteCommandCenter
        /*
        let remoteCommandCenter : RemoteCommandCenter = RemoteCommandCenter()
        remoteCommandCenter.delegate = self
        remoteCommandCenter.initMPRemoteCommandCenter()
        */
    }
    
    func initNetworkServer()
    {
        let serverDomain : String = NSBundle.mainBundle().objectForInfoDictionaryKey("serverDomain") as! String
        let serverPort : String = NSBundle.mainBundle().objectForInfoDictionaryKey("serverPort") as! String
        
        networkServer = NetworkService(domain: serverDomain, port: serverPort)
    }
    
    //MARK:
    //MARK: 🅰️  application functions
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        initNetworkServer()
        
        initServer()
        
        //copy media files to Cache directory
        CopyBundleFilesToCache()
        
        initRootViewController()
        
        initPlayerAndView()
        
        //initRemoteCommandCenter()
        
        initAVAudioSession()
        
        //initMPNowPlayingInfoCenter()
        
        initObserver()
        
        return true
    }

    func applicationDidEnterBackground(application: UIApplication) {
        stateAvtive = false
    }

    func applicationWillEnterForeground(application: UIApplication) {
        stateAvtive = true
    }

    func applicationDidBecomeActive(application: UIApplication) {
        stateAvtive = true
    }

    //MARK:
    //MARK: 🎵  player functions
    
    func togglePlayOrPause()
    {
        player.togglePlayOrPause()
    }
    
    func play()
    {
        player.play()
    }
    
    func pause()
    {
        player.pause()
    }
    
    func setPayerPlayingStatus(#play : Bool) -> Void
    {
        if play
        {
            player.play()
        }
        else
        {
            player.pause()
        }
        
        refreshView()
    }

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        
        var switchToNext : Bool = true
        
        if server.playOnceAgain
        {
            switchToNext = false
            
            //取消再放一遍状态
            //RemoteCommandCenter().refreshPlayAgainCommandView(active: false)
            server.playOnceAgain = false
        }
        
        refreshPlayerAndView(switchToNext: switchToNext)
        
        setPayerPlayingStatus(play: true)
    }
    
    func initAVAudioSession () -> Void
    {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }
    
    //初始化player,设定当前场景相关音频内容
    func initPlayer () -> Void
    {
        let playContent = server.playInfo
        
        let cachePath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as! String
        
        let playFileName : String = playContent.localUrl
        
        let playURL : NSURL = NSURL(fileURLWithPath: "\(cachePath)/resource/media/\(playFileName)")!

        //若音频文件不存在，则切换至下一首
        if NSFileManager.defaultManager().fileExistsAtPath(playURL.relativePath!) == false
        {
            //server.currentIndexOfScene++
            initPlayer()
            
            return
        }

        var error : NSError?
        
        player = audioPlayer(contentsOfURL: playURL, error: &error)
        
        
//        #if DEBUG_VERSION
        //println("DEBUG_VERSION")
            //测试，仅播放最后15'
        //player.currentTime = player.duration - 15
//        #endif
        
        //player.delegate = self
    }
    
    
    func refreshPlayer() -> Void
    {
        var prevPlayingStatus : Bool = player.bePlaying
        
        initPlayer()
        
        if prevPlayingStatus
        {
            player.play()
        }
    }
    
    //MARK:
    //MARK: 🔥  view更新相关方法
    
    //初始化、更新MPRemoteCommandCenter视图
    /*
    func initMPNowPlayingInfoCenter () -> Void
    {
        nowPlayingCenterController = NowPlayingInfoCenterController(app: self , server : self.server)
    }
    
    func updateMPNowPlayingInfoCenter () -> Void
    {
        if let nowPlayingCenter = nowPlayingCenterController
        {
            nowPlayingCenterController.refresh()
        }
    }
    */
    func initPlayerAndView () -> Void
    {
        initPlayer()
        
        refreshView()
    }
    
    func refreshView() -> Void
    {
        //updateMPNowPlayingInfoCenter()
        
        /*
        //若为主界面，刷新界面
        if let rootViewController : mainViewController = window?.rootViewController as? mainViewController
        {
            rootViewController.model = server.playInfo
        }
        */
    }
    
    
    //刷新player和相关视觉呈现view
    func refreshPlayerAndView(#switchToNext : Bool)
    {
        if switchToNext
        {
            //server.currentIndexOfScene++
        }
        
        refreshPlayer()
        refreshView()
    }
    
    func changeTitleOfNowPlayingInfoCenter(title : String)
    {
        
    }
    
    //MARK:
    //MARK: 💪  delegate动作接口
    
    //切换场景
    func switchScene (targetScene : String) -> Void
    {
        if targetScene != server.currentScene
        {
            server.currentScene = targetScene
            
            refreshPlayerAndView(switchToNext: false)
        }
    }
    
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
        player.play()
    }
    
    func playOnceAgain (isAgain : Bool = true) -> Void
    {
        server.playOnceAgain = isAgain
    }
    
    func childLikeCurrentAudio () -> Void
    {
        //获取当前音频id，提交孩子喜好至服务端
        //let playItemId : String = server.currentPlayContent()["id"]!
        /*
        networkServer.childLike(playItemId: playItemId, like: true, callback: {
            (response,error) -> Void in
            
            println(response)
            println(error)
        })
        */
    }
    
    func childDislikeCurrentAudio () -> Void
    {
        //获取当前音频id，提交孩子喜好至服务端
        let playItemId : String = server.playInfo.id
        
        networkServer.childLike(playItemId: playItemId, like: false, callback: {
            (response,error) -> Void in
            
            println(response)
            println(error)
        })
        
        //切换至下一音频
        refreshPlayerAndView(switchToNext: true)
        
    }
    
    func initResignProgress ()
    {
        if NSUserDefaults.standardUserDefaults().objectForKey("childName") == nil && userHadViewSettings == false
        {
            userHadViewSettings = true
            
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let resignVC = storyboard.instantiateViewControllerWithIdentifier("userInfoSetting") as! userInformationViewController
            
            self.window?.rootViewController!.presentViewController(resignVC, animated: true, completion: nil)
        }
        
    }
    
    func signup() -> Void
    {
        func generate_uuid() -> String
        {
            let puuid : CFUUIDRef = CFUUIDCreate( nil )
            let uuidString : CFStringRef = CFUUIDCreateString( nil, puuid )
            let result : String = CFStringCreateCopy( nil, uuidString) as String

            return result
        }
        
        //临时验证
        let password : String = generate_uuid()
        let username : String = generate_uuid()
        
        networkServer.signupAndLogin(username: username, password: password, fullname: username, callback: {
            (response,error) -> Void in
            
            println(error)
        })
    }
    
    //MARK: 
    //MARK: 👀  observer
    func initObserver() -> Void
    {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("childAgeGroupChanged:"), name: "childAgeGroupChanged", object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("avaudioSessionInterruption:"), name: AVAudioSessionInterruptionNotification, object: nil)
        
    }
    
    func childAgeGroupChanged(notification : NSNotification) -> Void
    {
        println("childAgeGroupChanged")
        if let ageGroup : Int = (notification.object as! [String:Int])["age"]
        {
            
            
            server.setDataAndRefreshServer(dataFileName: "\(ageGroup).json")
            
            refreshPlayerAndView(switchToNext: false)
        }
        
    }
    
    func avaudioSessionInterruption(notification : NSNotification)
    {
        
        let interuption : NSDictionary = notification.userInfo!
        let interuptionType : UInt = interuption.valueForKey(AVAudioSessionInterruptionTypeKey) as! UInt
        
        
        if interuptionType == AVAudioSessionInterruptionType.Began.rawValue
        {
            
            player.pause()
        }
        else if interuptionType == AVAudioSessionInterruptionType.Ended.rawValue
        {
            UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1), dispatch_get_main_queue(), { () -> Void in
                
                //AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
                //AVAudioSession.sharedInstance().setActive(true, error: nil)
                
                self.player.play()
            })
            
            
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
            AVAudioSession.sharedInstance().setActive(true, error: nil)
            
        }
        
    }
    
    
    //MARK:
    //MARK: ❤️  loveProtocol
    func doLike() {
        
        
    }
    
    func doDislike() {
        
        
    }
    
}

