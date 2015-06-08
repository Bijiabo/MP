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
            if getCurrentScenePlaylist().count - 1 < currentIndexOfScene
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
            currentScene = subJson["name"].stringValue
            
            break
        }
    }
    
    func getCurrentScenePlaylist() -> [Dictionary<String,String>]
    {
        var list : [Dictionary<String,String>] = [Dictionary<String,String>]()
        
        for (key : String , subJson : JSON) in playlist
        {
            if subJson["name"].stringValue == currentScene
            {
                for (key1 : String , subJson1 : JSON) in subJson["list"]
                {
                    list.append([
                        "name" : subJson1["name"].stringValue,
                        "url": subJson1["url"].stringValue,
                        "tag": subJson1["tag"].stringValue
                        ])
                }
                
                break
            }
        }
        
        return list
    }
    
    //get next play content
    func nextPlayConent () -> Dictionary<String,String>
    {
        let index : Int = currentIndexOfScene + 1
        
        return _getPlayContent(index)
    }
    
    func currentPlayContent () -> Dictionary<String,String>
    {
        let index : Int = currentIndexOfScene
        
        return _getPlayContent(index)
    }
    
    func prevPlayContent () -> Dictionary<String,String>
    {
        let index : Int = currentIndexOfScene - 1
        
        return _getPlayContent(index)
    }
    
    private func _getPlayContent(index : Int) -> Dictionary<String,String>
    {
        var playContentIndex : Int = index
        
        let currentScenePlaylist : [Dictionary<String,String>] = getCurrentScenePlaylist()
        
        if currentScenePlaylist.count - 1 < index
        {
            playContentIndex = 0
        }
        
        if index < 0
        {
            playContentIndex = currentScenePlaylist.count - 1
        }
        
        let playContent : Dictionary<String,String> = currentScenePlaylist[playContentIndex]
        
        return playContent
    }
    
    
    func sceneList () -> Array<String>
    {
        var sceneArray : Array<String> = Array<String>()
        
        for (key : String , subJson : JSON) in playlist
        {
            sceneArray.append(subJson["name"].stringValue)
        }
        
        return sceneArray
    }
    
}