//
//  NowPlayingInfoCenter.swift
//  MP
//
//  Created by bijiabo on 15/6/12.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import MediaPlayer

// ViewController where View is NowPlayingCenter
class NowPlayingInfoCenterController: NSObject
{
    // model
    let app: protocol<sceneProtocol , playerDelegate>
    let server : ServerProtocol
    
    // view
    let view: MPNowPlayingInfoCenter = MPNowPlayingInfoCenter.defaultCenter()
    var viewModel: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
    init(app: protocol<sceneProtocol , playerDelegate> , server : ServerProtocol)
    {
        self.app = app
        self.server = server

        super.init()
        
        // app.currentPlayingItem
        // app.currentScene
        // app.currentUser
        
        //setupViewControls()
        
        // bind to model
//        app.player.addObserver(self, forKeyPath: "duration", options: NSKeyValueChangeNewKey, context: nil)
//        app.addObserver(self, forKeyPath: "currentScene", options: NSKeyValueChangeNewKey, context: nil)
//        
    }
    
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
    
        if keyPath == "duration"
        {
            setViewProperty(MPNowPlayingInfoPropertyElapsedPlaybackTime, value: 10);
        }
        
        if keyPath == "currentScene"
        {
            //
        }
    }
    
    func refresh()
    {
        /*
        let currentPlayItemContent : Dictionary<String,String> = server.playInfo as! Dictionary<String, String>
        let audioName : String = currentPlayItemContent["name"]!
        
        //        NowPlayingInfoCenterController(AlbumArtist: "磨耳朵", currentPlayItemName: audioName, imageName : server.currentScene, artist: "\(server.currentScene)磨耳朵", player: player)
        //
        //        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
        //            MPMediaItemPropertyAlbumArtist: AlbumArtist, // not displayed
        //            //MPMediaItemPropertyAlbumTitle: "磨耳朵",
        //            MPMediaItemPropertyTitle: currentPlayItemName,
        //            MPMediaItemPropertyArtist:  artist,
        //            MPMediaItemPropertyArtwork: artwork,
        //            MPNowPlayingInfoPropertyElapsedPlaybackTime : player.currentTime,
        //            MPNowPlayingInfoPropertyPlaybackRate : 1.0,
        //            MPMediaItemPropertyPlaybackDuration : player.duration
        //        ]

        let artist = "\(server.currentScene)磨耳朵"
        
        setViewProperty(MPMediaItemPropertyTitle, value: audioName)
        setViewProperty(MPMediaItemPropertyArtist, value: artist)
        setViewProperty(MPNowPlayingInfoPropertyElapsedPlaybackTime, value: 0 /*app.player.currentTime*/)
        setViewProperty(MPNowPlayingInfoPropertyPlaybackRate, value: 1.0)
        setViewProperty(MPMediaItemPropertyPlaybackDuration, value: 10/*app.player.duration*/)

        let artworkImage : UIImage = LockScreenView(imageName: server.currentScene, title: artist, description: audioName).image
        let artwork : MPMediaItemArtwork = MPMediaItemArtwork(image:  artworkImage)
        setViewProperty(MPMediaItemPropertyArtwork, value: artwork)
        */
    }
    
    func setViewProperty(propertyName: String, value: AnyObject)
    {
        viewModel[propertyName] = value;
        updateView();
    }
    
    func updateView()
    {
        view.nowPlayingInfo = viewModel;
    }
    
    func setupViewControls()
    {
        let remoteCommandCenter = MPRemoteCommandCenter.sharedCommandCenter()
        
        remoteCommandCenter.playCommand.addTarget(self, action: Selector("playCommand:"))

        remoteCommandCenter.pauseCommand.addTargetWithHandler { (event: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            //self.app.player.pause()
            return MPRemoteCommandHandlerStatus.Success
        }
        
        remoteCommandCenter.togglePlayPauseCommand.addTargetWithHandler { (event: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            return MPRemoteCommandHandlerStatus.Success
        }
        
        //切换模式
        ///*
        remoteCommandCenter.nextTrackCommand.addTargetWithHandler { (event: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            //self.setViewProperty(MPMediaItemPropertyTitle, value: "长按⏩键切换到XXX模式")
            
            //self.app.refreshPlayerAndView(switchToNext: true)
            
            return MPRemoteCommandHandlerStatus.Success
        }
        /*
        remoteCommandCenter.seekForwardCommand.addTargetWithHandler { (event: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            self.app.switchScene(targetScene: "午后")
            return MPRemoteCommandHandlerStatus.Success
        }
        */
        
        //child like
        remoteCommandCenter.likeCommand.localizedTitle = "😃 孩子喜欢"
        
        remoteCommandCenter.likeCommand.addTarget(self, action: Selector("childLike:"))
        //child dislike
        remoteCommandCenter.dislikeCommand.localizedTitle = "😞 孩子不喜欢"
        
        remoteCommandCenter.dislikeCommand.addTarget(self, action: Selector("dislikeCommand:"))
        remoteCommandCenter.bookmarkCommand.localizedTitle = "🎵 再放一遍"
        remoteCommandCenter.bookmarkCommand.addTarget(self, action: Selector("playAgain:"))
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        //app.becomeFirstResponder()
    }
    
    internal func pauseCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        //app.setPayerPlayingStatus(play: false)
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func playCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        //app.setPayerPlayingStatus(play: true)
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func togglePlayPauseCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        app.togglePlayOrPause()
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func previousTrackCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func nextTrackCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        //app.refreshPlayerAndView(switchToNext: true)
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func childLike (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        let commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
        
        commandCenter.likeCommand.active = true
        commandCenter.dislikeCommand.active = false
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func dislikeCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        let commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
        
        commandCenter.likeCommand.active = false
        commandCenter.dislikeCommand.active = false
        
        //app.childDislikeCurrentAudio()
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func playAgain (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        let previousCommandActiveStatus : Bool = MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.active
        
        triggerPlayAgainCommand( !previousCommandActiveStatus )
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func triggerPlayAgainCommand (again : Bool) -> Void
    {
        //app.playOnceAgain(isAgain: again)
        refreshPlayAgainCommandView(active: again)
    }
    
    internal func refreshPlayAgainCommandView(#active : Bool) -> Void
    {
        let commandCenter = MPRemoteCommandCenter.sharedCommandCenter()
        
        commandCenter.bookmarkCommand.active = active
        
        if active
        {
            commandCenter.bookmarkCommand.localizedTitle = "🎵 取消再放一遍"
        }
        else
        {
            commandCenter.bookmarkCommand.localizedTitle = "🎵 再放一遍"
        }
        
    }
}
