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
    
    var currentSceneIndex : Int = 0
    
    var stateAvtive : Bool = true
    
    var networkServer : NetworkService!

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        //set network server
        networkServer = NetworkService(domain: "localhost", port: "3000")
        
        //set local server
        server = Server()
        server.delegate = self
        
        //copy media files to Cache directory
        CopyBundleFilesToCache()
        
        //set root VC
        let rootViewController : mainViewController = window?.rootViewController as! mainViewController
        
        rootViewController.delegate = self
        
        initPlayerAndView()
        
        //set MPRemoteCommandCenter
        let remoteCommandCenter : RemoteCommandCenter = RemoteCommandCenter()
        remoteCommandCenter.delegate = self
        remoteCommandCenter._initMPRemoteCommandCenter()
        
        _initAVAudioSession()
        
        updateMPNowPlayingInfoCenter()
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
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

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
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
            
            RemoteCommandCenter().playAgainCommandActive(active: false)
            server.playOnceAgain = false
        }
        
        refreshPlayerAndView(switchToNext: switchToNext)
        
        setPayerPlayingStatus(play: true)
    }
    
    private func _initAVAudioSession () -> Void
    {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }
    
    //更新MPRemoteCommandCenter视图
    func updateMPNowPlayingInfoCenter () -> Void
    {
        
        let currentPlayItemContent : Dictionary<String,String> = server.currentPlayContent()
        
        let currentPlayItemName : String = currentPlayItemContent["name"]!
        let _MPMediaItemPropertyArtist: String = server.currentScene
        
        // LOCK/CONTROLCENTER: Title / AlbumTitle - Artist
        // REMOTE MENU: Title / Artist
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
            MPMediaItemPropertyAlbumArtist: "磨耳朵", // not displayed
            //MPMediaItemPropertyAlbumTitle: "磨耳朵",
            MPMediaItemPropertyTitle: currentPlayItemName,
            MPMediaItemPropertyArtist:  "\(_MPMediaItemPropertyArtist)磨耳朵",
            MPMediaItemPropertyArtwork: MPMediaItemArtwork(image:  LockScreenView(imageName: server.currentScene, title: "\(server.currentScene)磨耳朵", description: currentPlayItemName).image ),
            MPNowPlayingInfoPropertyElapsedPlaybackTime : player.currentTime,
            MPNowPlayingInfoPropertyPlaybackRate : 1.0,
            MPMediaItemPropertyPlaybackDuration : player.duration
        ]
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
        
        //测试，仅播放最后15'
        player.currentTime = player.duration - 15
        
        player.delegate = self
    }
    
    func initPlayerAndView () -> Void
    {
        initPlayer()
        
        refreshView()
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

    
    func refreshView()
    {
        //refresh mainVC
        if stateAvtive
        {
            if let rootViewController : mainViewController = window?.rootViewController as? mainViewController
            {
                var model : Dictionary<String,AnyObject> = server.currentPlayContent()
                model["playing"] = player.playing
                model["currentScene"] = server.currentScene
                model["scenelist"] = server.sceneList()
                
                rootViewController.model = model
            }
        }
        
        //refresh  MPInfo
        updateMPNowPlayingInfoCenter()
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
    
    func audioPlayerDecodeErrorDidOccur(player: AVAudioPlayer!, error: NSError!) {
        //println( "audioPlayerDecodeErrorDidOccur" )
        
        //println(error)
    }
    
    func playOnceAgain (isAgain : Bool = true) -> Void
    {
        println("playOnceAgain!!!!!!!!!!!!!!!!!!!!!!!")
        
        server.playOnceAgain = isAgain
    }
    
    
    /*
    func audioPlayerBeginInterruption(player: AVAudioPlayer!) {
        println("audioPlayerBeginInterruption")
    }
    */
}

