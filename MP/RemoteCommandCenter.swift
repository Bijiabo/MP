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
    
    
    func _initMPRemoteCommandCenter () -> Void
    {
        //MARK : MPRemoteCommandCenter
        
        MPRemoteCommandCenter.sharedCommandCenter().pauseCommand.addTargetWithHandler {
            (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            
            self.delegate.setPayerPlayingStatus(play: false)
            
            return MPRemoteCommandHandlerStatus.Success
        }
        
        MPRemoteCommandCenter.sharedCommandCenter().playCommand.addTargetWithHandler {
            (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
            
            self.delegate.setPayerPlayingStatus(play: true)
            
            return MPRemoteCommandHandlerStatus.Success
        }
        
        MPRemoteCommandCenter.sharedCommandCenter().togglePlayPauseCommand.addTargetWithHandler(
            {
                (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
                
                self.delegate.togglePlayPause()
                
                return MPRemoteCommandHandlerStatus.Success
            }
        )
        
        /*
        MPRemoteCommandCenter.sharedCommandCenter().nextTrackCommand.addTargetWithHandler(
        {
        (event : MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
        
        self.refreshPlayerAndView(switchToNext: true)
        
        return MPRemoteCommandHandlerStatus.Success
        })
        */
        
        MPRemoteCommandCenter.sharedCommandCenter().nextTrackCommand.addTarget(self, action: Selector("nextTrackCommand:") )
        
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
                MPRemoteCommandCenter.sharedCommandCenter().dislikeCommand.active = false
                
                self.delegate.refreshPlayerAndView(switchToNext: true)
                
                return MPRemoteCommandHandlerStatus.Success
        }
        
        MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.localizedTitle = "🎵 再放一遍"
        MPRemoteCommandCenter.sharedCommandCenter().bookmarkCommand.addTargetWithHandler
            {
                (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus in
                
                return MPRemoteCommandHandlerStatus.Success
        }
        
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
        self.delegate.becomeFirstResponder()
    }
    
    
    //test
    func nextTrackCommand (e: MPRemoteCommandEvent!) -> MPRemoteCommandHandlerStatus
    {
        self.delegate.refreshPlayerAndView(switchToNext: true)
        
        return MPRemoteCommandHandlerStatus.Success
    }
    
}