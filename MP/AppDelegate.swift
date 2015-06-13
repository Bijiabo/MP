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

class AppDelegate: UIResponder, UIApplicationDelegate , AVAudioPlayerDelegate
{
    var window: UIWindow?
    
    var player : audioPlayer!
    var server : Server!
    var networkServer : NetworkService!
    
    var stateAvtive : Bool = true
    var userHadViewSettings : Bool = false
    
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
        let rootViewController : mainViewController = window?.rootViewController as! mainViewController
        rootViewController.delegate = self
    }

    func initRemoteCommandCenter() -> Void
    {
        //set MPRemoteCommandCenter
        let remoteCommandCenter : RemoteCommandCenter = RemoteCommandCenter()
        remoteCommandCenter.delegate = self
        remoteCommandCenter.initMPRemoteCommandCenter()
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
        
        initRemoteCommandCenter()
        
        initAVAudioSession()
        
        initMPNowPlayingInfoCenter()
        
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
    
    internal func togglePlayPause () -> Void
    {
        setPayerPlayingStatus(play: !player.playing)
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
            RemoteCommandCenter().refreshPlayAgainCommandView(active: false)
            server.playOnceAgain = false
        }
        
        
        refreshPlayerAndView(switchToNext: switchToNext)
        
        setPayerPlayingStatus(play: true)
    }
    
    private func initAVAudioSession () -> Void
    {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }
    
    //初始化player,设定当前场景相关音频内容
    func initPlayer () -> Void
    {
        let playContent = server.currentPlayContent()
        
        let cachePath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as! String
        
        let playFileName : String = playContent["url"]!
        
        let playURL : NSURL = NSURL(fileURLWithPath: "\(cachePath)/resource/media/\(playFileName)")!

        //若音频文件不存在，则切换至下一首
        if NSFileManager.defaultManager().fileExistsAtPath(playURL.relativePath!) == false
        {
            server.currentIndexOfScene++
            initPlayer()
            
            return
        }

        var error : NSError?
        
        player = audioPlayer(contentsOfURL: playURL, error: &error)
        
        player.prepareToPlay()
        
        #if DEBUG_VERSION
            println("DEBUG_VERSION")
            //测试，仅播放最后15'
            player.currentTime = player.duration - 15
        #endif
            
        player.delegate = self
    }
    
    
    func refreshPlayer() -> Void
    {
        var prevPlayingStatus : Bool = player.playing
        
        initPlayer()
        
        if prevPlayingStatus
        {
            player.play()
        }
    }
    
    //MARK:
    //MARK: 🔥  view更新相关方法
    
    //初始化、更新MPRemoteCommandCenter视图
    func initMPNowPlayingInfoCenter () -> Void
    {
        updateMPNowPlayingInfoCenter()
    }
    
    func updateMPNowPlayingInfoCenter () -> Void
    {
        let currentPlayItemContent : Dictionary<String,String> = server.currentPlayContent()
        
        let audioName : String = currentPlayItemContent["name"]!
        
        NowPlayingInfoCenter(AlbumArtist: "磨耳朵", currentPlayItemName: audioName,imageName : server.currentScene, Artist: "\(server.currentScene)磨耳朵", player: player)
        
    }
    
    func initPlayerAndView () -> Void
    {
        initPlayer()
        
        refreshView()
    }
    
    func refreshView() -> Void
    {
        //refresh  MPInfo
        updateMPNowPlayingInfoCenter()
        
        //refresh mainVC
        if !stateAvtive {return }
        
        //若为主界面，刷新界面
        if let rootViewController : mainViewController = window?.rootViewController as? mainViewController
        {
            var model : Dictionary<String,AnyObject> = server.currentPlayContent()
            model["playing"] = player.playing
            model["currentScene"] = server.currentScene
            model["scenelist"] = server.sceneList()
            
            rootViewController.model = model
        }
    }
    
    
    //刷新player和相关视觉呈现view
    func refreshPlayerAndView(#switchToNext : Bool)
    {
        if switchToNext
        {
            server.currentIndexOfScene++
        }
        
        refreshPlayer()
        refreshView()
    }
    
    //MARK:
    //MARK: 💪  delegate动作接口
    
    //切换场景
    func switchScene (#targetScene : String) -> Void
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
        let playItemId : String = server.currentPlayContent()["id"]!
        
        networkServer.childLike(playItemId: playItemId, like: true, callback: {
            (response,error) -> Void in
            
            println(response)
            println(error)
        })
    }
    
    func childDislikeCurrentAudio () -> Void
    {
        //获取当前音频id，提交孩子喜好至服务端
        let playItemId : String = server.currentPlayContent()["id"]!
        
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
        //临时验证
        let password : String = NSUUID().UUIDString
        let username : String = NSUUID().UUIDString
        
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
}

