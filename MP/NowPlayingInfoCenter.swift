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
    let app: AppDelegate
    
    // view
    let view: MPNowPlayingInfoCenter = MPNowPlayingInfoCenter.defaultCenter()
    var viewModel: Dictionary<String, AnyObject> = Dictionary<String, AnyObject>()
    
    init(app: AppDelegate)
    {
        self.app = app

        super.init()
        
        // app.currentPlayingItem
        // app.currentScene
        // app.currentUser
        
        setupViewControls()
        
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
        let currentPlayItemContent : Dictionary<String,String> = app.server.currentPlayContent()
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

        let artist = "\(app.server.currentScene)磨耳朵"
        
        setViewProperty(MPMediaItemPropertyTitle, value: audioName)
        setViewProperty(MPMediaItemPropertyArtist, value: artist)

        let artworkImage : UIImage = LockScreenView(imageName: app.server.currentScene, title: artist, description: audioName).image
        let artwork : MPMediaItemArtwork = MPMediaItemArtwork(image:  artworkImage)
        setViewProperty(MPMediaItemPropertyArtwork, value: artwork)
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
        
        remoteCommandCenter.playCommand.addTargetWithHandler { (event: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            self.app.player.play()
            return MPRemoteCommandHandlerStatus.Success
        }

        remoteCommandCenter.pauseCommand.addTargetWithHandler { (event: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            self.app.player.pause()
            return MPRemoteCommandHandlerStatus.Success
        }
        
        remoteCommandCenter.togglePlayPauseCommand.addTargetWithHandler { (event: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            return MPRemoteCommandHandlerStatus.Success
        }
        
        remoteCommandCenter.nextTrackCommand.addTargetWithHandler { (event: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            //self.setViewProperty(MPMediaItemPropertyTitle, value: "长按⏩键切换到XXX模式")
            self.app.refreshPlayerAndView(switchToNext: true)
            
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
        
    }
    
    internal func childLike (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        MPRemoteCommandCenter.sharedCommandCenter().likeCommand.active = true
        MPRemoteCommandCenter.sharedCommandCenter().dislikeCommand.active = false
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func dislikeCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        MPRemoteCommandCenter.sharedCommandCenter().likeCommand.active = false
        MPRemoteCommandCenter.sharedCommandCenter().dislikeCommand.active = false
        
        self.app.childDislikeCurrentAudio()
        
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
        self.app.playOnceAgain(isAgain: again)
        refreshPlayAgainCommandView(active: again)
    }
    
    internal func refreshPlayAgainCommandView(#active : Bool) -> Void
    {
        MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.active = active
        
        if active
        {
            MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.localizedTitle = "🎵 取消再放一遍"
        }
        else
        {
            MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.localizedTitle = "🎵 再放一遍"
        }
        
    }
}
