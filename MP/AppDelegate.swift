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
        
        //初始化Player 及 主界面
        initPlayerAndView()
        
        //set MPRemoteCommandCenter
        let remoteCommandCenter : RemoteCommandCenter = RemoteCommandCenter()
        remoteCommandCenter.delegate = self
        remoteCommandCenter.initMPRemoteCommandCenter()
        
        initAVAudioSession()
        
        updateMPNowPlayingInfoCenter()
        
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
    
    //更新MPRemoteCommandCenter视图
    func updateMPNowPlayingInfoCenter () -> Void
    {
        let currentPlayItemContent : Dictionary<String,String> = server.currentPlayContent()
        
        let audioName : String = currentPlayItemContent["name"]!
        
        NowPlayingInfoCenter(AlbumArtist: "磨耳朵", currentPlayItemName: audioName,imageName : server.currentScene, Artist: "\(server.currentScene)磨耳朵", player: player)
        
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
}

