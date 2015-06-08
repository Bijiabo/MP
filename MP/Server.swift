//

//  order.swift

//  MP

//

//  Created by bijiabo on 15/6/2.

//  Copyright (c) 2015年 JYLabs. All rights reserved.

//



import Foundation



class Server {
    
    var delegate : AppDelegate!
    
    //playlist and currentScene
    var playlist : JSON = JSON([])
    var currentScene : String = ""
    
    var currentIndexOfScene : Int = 0
    {
        didSet
        {
            if playlist[currentScene].arrayValue.count - 1 < currentIndexOfScene
            {
                currentIndexOfScene = 0
            }
        }
    }
    
    init()
    {
        playlist = dataLoader(dataFileName : "playlist.json" , pathInBundle : "resource/data").data
        
        for (key : String , subJson : JSON) in playlist
        {
            currentScene = key
            break
        }
    }
    
    //get next play content
    func nextPlayConent () -> Dictionary<String,AnyObject>
    {
        let index : Int = currentIndexOfScene + 1
        
        return _getPlayContent(index)
    }
    
    func currentPlayContent () -> Dictionary<String,AnyObject>
    {
        let index : Int = currentIndexOfScene
        
        return _getPlayContent(index)
    }
    
    func prevPlayContent () -> Dictionary<String,AnyObject>
    {
        let index : Int = currentIndexOfScene - 1
        
        return _getPlayContent(index)
    }
    
    private func _getPlayContent(index : Int) -> Dictionary<String,AnyObject>
    {
        var playContentIndex : Int = index
        
        if playlist[currentScene].arrayValue.count - 1 < index
        {
            playContentIndex = 0
        }
        
        if index < 0
        {
            playContentIndex = playlist[currentScene].arrayValue.count - 1
        }
        
        let playContent = playlist[currentScene][playContentIndex]
        
        var playContentDictionary : Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
        
        for (key : String , subJson : JSON) in playContent
        {
            playContentDictionary[key] = subJson.stringValue
        }
        
        return playContentDictionary
    }
    
    
    func sceneList () -> Array<String>
    {
        var sceneArray : Array<String> = Array<String>()
        
        for (key : String , subJson : JSON) in playlist
        {
            sceneArray.append(key)
        }
        
        return sceneArray
    }
    
}