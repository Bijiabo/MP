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

class NowPlayingInfoCenter: NSObject {
    init(AlbumArtist : String , currentPlayItemName : String ,imageName : String , Artist : String , player : AVAudioPlayer )
    {
        let artWorkImage : UIImage = LockScreenView(imageName: imageName, title: Artist, description: currentPlayItemName).image
        
        let artWork : MPMediaItemArtwork = MPMediaItemArtwork(image:  artWorkImage)
        
        MPNowPlayingInfoCenter.defaultCenter().nowPlayingInfo = [
            MPMediaItemPropertyAlbumArtist: AlbumArtist, // not displayed
            //MPMediaItemPropertyAlbumTitle: "磨耳朵",
            MPMediaItemPropertyTitle: currentPlayItemName,
            MPMediaItemPropertyArtist:  Artist,
            MPMediaItemPropertyArtwork: artWork,
            MPNowPlayingInfoPropertyElapsedPlaybackTime : player.currentTime,
            MPNowPlayingInfoPropertyPlaybackRate : 1.0,
            MPMediaItemPropertyPlaybackDuration : player.duration
        ]
    }
}
