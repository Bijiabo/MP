//
//  RemoteCommandCenter.swift
//  MP
//
//  Created by bijiabo on 15/6/8.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation
import MediaPlayer
/*
class RemoteCommandCenter : UIResponder {
    
    var delegate : AppDelegate!
    
    let commandCenter  = MPRemoteCommandCenter.sharedCommandCenter()
    
    func initMPRemoteCommandCenter () -> Void
    {
        commandCenter.pauseCommand.addTargetWithHandler {
            (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            
            self.delegate.setPayerPlayingStatus(play: false)
            
            return MPRemoteCommandHandlerStatus.Success
        }
        
        commandCenter.playCommand.addTarget(self, action: Selector("playCommand:"))
        
        commandCenter.togglePlayPauseCommand.addTarget(self, action: Selector("togglePlayPauseCommand:"))
        
        commandCenter.nextTrackCommand.addTarget(self, action: Selector("nextTrackCommand:") )

        commandCenter.previousTrackCommand.addTarget(self, action: Selector("previousTrackCommand:"))
        
        //child like
        commandCenter.likeCommand.localizedTitle = "😃 孩子喜欢"
        
        commandCenter.likeCommand.addTarget(self, action: Selector("childLike:"))
        //child dislike
        commandCenter.dislikeCommand.localizedTitle = "😞 孩子不喜欢"
        
        commandCenter.dislikeCommand.addTarget(self, action: Selector("dislikeCommand:"))
        commandCenter.bookmarkCommand.localizedTitle = "🎵 再放一遍"
        commandCenter.bookmarkCommand.addTarget(self, action: Selector("playAgain:"))
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.delegate.becomeFirstResponder()
    }
    
    
    internal func pauseCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        self.delegate.setPayerPlayingStatus(play: false)
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func playCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        self.delegate.setPayerPlayingStatus(play: true)
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func togglePlayPauseCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        self.delegate.togglePlayPause()
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func previousTrackCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func nextTrackCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        
        
        self.delegate.refreshPlayerAndView(switchToNext: true)
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func childLike (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        commandCenter.likeCommand.active = true
        commandCenter.dislikeCommand.active = false
    
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func dislikeCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        commandCenter.likeCommand.active = false
        commandCenter.dislikeCommand.active = false
        
        self.delegate.childDislikeCurrentAudio()
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func playAgain (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        let previousCommandActiveStatus : Bool = commandCenter.bookmarkCommand.active
        
        triggerPlayAgainCommand( !previousCommandActiveStatus )
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func triggerPlayAgainCommand (again : Bool) -> Void
    {
        self.delegate.playOnceAgain(isAgain: again)
        refreshPlayAgainCommandView(active: again)
    }
    
    internal func refreshPlayAgainCommandView(#active : Bool) -> Void
    {
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
*/