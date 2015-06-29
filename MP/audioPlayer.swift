//
//  audioPlayer.swift
//  MP
//
//  Created by bijiabo on 15/6/8.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class audioPlayer: AVAudioPlayer , playerProtocol
{
    var bePlaying : Bool = false
    
    //切换播放状态
    override func play() -> Bool
    {
        bePlaying = super.play()
        
        return bePlaying
    }
    
    override func pause()
    {
        bePlaying = false
        
        super.pause()
    }
    
    func togglePlayOrPause()
    {
        if playing
        {
            pause()
            bePlaying = false
        }
        else
        {
            play()
            bePlaying = true
        }

    }
    
    //再放一遍
    func playOnceAgain()
    {
        numberOfLoops++
    }
}
