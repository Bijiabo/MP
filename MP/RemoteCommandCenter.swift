//
//  RemoteCommandCenter.swift
//  MP
//
//  Created by bijiabo on 15/6/8.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation
import MediaPlayer

class RemoteCommandCenter : UIResponder {
    
    var delegate : AppDelegate!
    
    
    func initMPRemoteCommandCenter () -> Void
    {
        MPRemoteCommandCenter.sharedCommandCenter().pauseCommand.addTargetWithHandler {
            (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            
            self.delegate.setPayerPlayingStatus(play: false)
            
            return MPRemoteCommandHandlerStatus.Success
        }
        
        MPRemoteCommandCenter.sharedCommandCenter().playCommand.addTarget(self, action: Selector("playCommand:"))
        
        MPRemoteCommandCenter.sharedCommandCenter().togglePlayPauseCommand.addTarget(self, action: Selector("togglePlayPauseCommand:"))
        
        MPRemoteCommandCenter.sharedCommandCenter().nextTrackCommand.addTarget(self, action: Selector("nextTrackCommand:") )

        MPRemoteCommandCenter.sharedCommandCenter().previousTrackCommand.addTarget(self, action: Selector("previousTrackCommand:"))
        
        //child like
        MPRemoteCommandCenter.sharedCommandCenter().likeCommand.localizedTitle = "😃 孩子喜欢"
        
        MPRemoteCommandCenter.sharedCommandCenter().likeCommand.addTarget(self, action: Selector("childLike:"))
        //child dislike
        MPRemoteCommandCenter.sharedCommandCenter().dislikeCommand.localizedTitle = "😞 孩子不喜欢"
        
        MPRemoteCommandCenter.sharedCommandCenter().dislikeCommand.addTarget(self, action: Selector("dislikeCommand:"))
        MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.localizedTitle = "🎵 再放一遍"
        MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.addTarget(self, action: Selector("playAgain:"))
        
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
        self.delegate.refreshPlayerAndView(switchToNext: true)
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
    internal func nextTrackCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        
        self.delegate.refreshPlayerAndView(switchToNext: true)
        
        return MPRemoteCommandHandlerStatus.Success
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
        
        self.delegate.refreshPlayerAndView(switchToNext: true)
        
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
        self.delegate.playOnceAgain(isAgain: again)
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