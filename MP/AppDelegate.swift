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
    
    var player : AVAudioPlayer!

    var server : Server!
    
    var currentSceneIndex : Int = 0
    
    var stateAvtive : Bool = true

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool
    {
        server = Server()
        server.delegate = self
        
        //copy media files to Cache directory
        //copyToCashDir(formPathInBundle: "resource/media", toPathInCache: "media")
        
        //set root VC
        let rootViewController : mainViewController = window?.rootViewController as! mainViewController
        
        rootViewController.delegate = self
        rootViewController.server = server
        
        //MARK : player
        refreshPlayer()
        
        _initMPRemoteCommandCenter()
        
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
    
    internal func togglePlayPause () -> Bool
    {
        println("player:")
        println(player.url )
        
        if player.playing
        {
            player.pause()
        }
        else
        {
            player.play()
        }
        
        refreshView()
      
        return player.playing
    }

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        
        player.currentTime = NSTimeInterval(0)
        
        player.play()
        
        updateMPNowPlayingInfoCenter()
    }
    
    private func _initAVAudioSession () -> Void
    {
        AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback, error: nil)
        
        AVAudioSession.sharedInstance().setActive(true, error: nil)
    }
    
    private func _initMPRemoteCommandCenter () -> Void
    {
        //MARK : MPRemoteCommandCenter
        
        MPRemoteCommandCenter.sharedCommandCenter().pauseCommand.addTargetWithHandler {
            (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            
            self.togglePlayPause()
            
            return MPRemoteCommandHandlerStatus.Success
        }
        
        MPRemoteCommandCenter.sharedCommandCenter().playCommand.addTargetWithHandler {
            (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            
            self.togglePlayPause()
            
            return MPRemoteCommandHandlerStatus.Success
        }
        
        MPRemoteCommandCenter.sharedCommandCenter().togglePlayPauseCommand.addTargetWithHandler {
            (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            
            self.togglePlayPause()
            
            return MPRemoteCommandHandlerStatus.Success
        }
        
        MPRemoteCommandCenter.sharedCommandCenter().nextTrackCommand.addTargetWithHandler {
            (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            
            return MPRemoteCommandHandlerStatus.Success
        }
        
        MPRemoteCommandCenter.sharedCommandCenter().previousTrackCommand.addTargetWithHandler {
            (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            
            return MPRemoteCommandHandlerStatus.Success
        }
        
        
        //child like
        MPRemoteCommandCenter.sharedCommandCenter().likeCommand.localizedTitle = "😃 孩子喜欢"
        
        MPRemoteCommandCenter.sharedCommandCenter().likeCommand.addTargetWithHandler
            {
                (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
                
                MPRemoteCommandCenter.sharedCommandCenter().likeCommand.active = true
                MPRemoteCommandCenter.sharedCommandCenter().dislikeCommand.active = false
                
                return MPRemoteCommandHandlerStatus.Success
        }
        
        //child dislike
        MPRemoteCommandCenter.sharedCommandCenter().dislikeCommand.localizedTitle = "😞 孩子不喜欢"
        
        MPRemoteCommandCenter.sharedCommandCenter().dislikeCommand.addTargetWithHandler
            {
                (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
                
                MPRemoteCommandCenter.sharedCommandCenter().likeCommand.active = false
                MPRemoteCommandCenter.sharedCommandCenter().dislikeCommand.active = true
                
                return MPRemoteCommandHandlerStatus.Success
        }
        
        MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.localizedTitle = "🎵 再放一遍"
        MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.addTargetWithHandler
            {
                (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
                
                return MPRemoteCommandHandlerStatus.Success
        }
    }
    
    func updateMPNowPlayingInfoCenter () -> Void
    {
        
        let currentPlayItemContent : Dictionary<String,AnyObject> = server.currentPlayContent()
        
        let currentPlayItemName : String = currentPlayItemContent["name"] as! String
        let _MPMediaItemPropertyArtist: String = server.currentScene
        
        // LOCK/CONTROLCENTER: Title / AlbumTitle - Artist
        // REMOTE MENU: Title / Artist
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
            MPMediaItemPropertyAlbumArtist: "磨耳朵", // not displayed
//            MPMediaItemPropertyAlbumTitle: "磨耳朵",
            MPMediaItemPropertyTitle: currentPlayItemName,
            MPMediaItemPropertyArtist:  "\(_MPMediaItemPropertyArtist)磨耳朵"
            //,MPMediaItemPropertyArtwork: MPMediaItemArtwork(image:  UIImage(named: "resource/image/logo.jpg") )
        ]
    }
    
    func copyToCashDir (#formPathInBundle : String , toPathInCache : String ) -> Void
    {
        let fileManager : NSFileManager = NSFileManager.defaultManager()
        let originalFilePath : NSURL = NSBundle.mainBundle().resourceURL!.URLByAppendingPathComponent(formPathInBundle, isDirectory: true)
        
        let cachePath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as! String
        
        println(cachePath)
        
        //if media directory isn't exists
        
        var err : NSError?
        var isDir : ObjCBool = true
        
        let ifMediaFileInCacheExists : Bool = fileManager.fileExistsAtPath("\(cachePath)/media", isDirectory : &isDir)
        
        if !ifMediaFileInCacheExists
        {
            fileManager.copyItemAtURL(originalFilePath, toURL: NSURL(fileURLWithPath:"\(cachePath)/\(toPathInCache)")!, error: &err)
            
            return
        }
        
        
        //check media file lists
        
        let originalFileList : [AnyObject] = (fileManager.contentsOfDirectoryAtURL(originalFilePath, includingPropertiesForKeys: nil, options: nil, error: nil) as [AnyObject]?)!

        for fileName in originalFileList
        {
            let fileNameString: AnyObject = fileName.lastPathComponent
        
            let targetURL : NSURL = NSURL(fileURLWithPath: "\(cachePath)/\(toPathInCache)/\(fileNameString)")!
            
            var isNotDir : ObjCBool = false
            
            let ifMediaItemFileInCacheExists : Bool = fileManager.fileExistsAtPath(targetURL.absoluteString! , isDirectory : &isNotDir)
            if !ifMediaItemFileInCacheExists
            {
                var error : NSError?
                
                fileManager.copyItemAtURL(fileName as! NSURL, toURL: targetURL , error: &error)
            }
        }

    }
    
    
    func refreshPlayer () -> Void
    {
        var prevPlayingStatus : Bool = false
        
        if player != nil
        {
            prevPlayingStatus = player.playing
        }
        
        let playContent = server.currentPlayContent()
        
        let cachePath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as! String

        
        let playFileName : String = playContent["url"] as! String
        
        let bundlePath : NSURL = NSBundle.mainBundle().URLForResource(playFileName, withExtension: "", subdirectory: "resource/media")!
        
        let playURL : NSURL = bundlePath
//        NSURL(fileURLWithPath: "\(cachePath)/media/\(playFileName)")!
        
        player = AVAudioPlayer(contentsOfURL: playURL, error: nil)
        player.delegate = self
        
        if prevPlayingStatus
        {
            player.play()
        }
        
        refreshView()
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
    
    func switchScene (#targetScene : String) -> Void
    {
        if targetScene != server.currentScene
        {
            server.currentScene = targetScene
            
            refreshPlayer()
        }
    }
}

