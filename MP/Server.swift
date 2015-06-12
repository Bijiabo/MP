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
    
    //当前音频是否再次播放一遍
    var playOnceAgain : Bool = false
    
    //当前场景音频播放index
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
        setData(dataFileName : "playlist.json" )
        
        initScene()
    }
    
    init(fileName : String)
    {
        setData(dataFileName : fileName )
        
        initScene()
    }
    
    init(JSONData data: JSON)
    {
        setData(data: data)
        
        initScene()
    }
    
    //初始化播放列表数据
    func setData(dataFileName fileName : String ) -> Void
    {
        playlist = dataLoader(dataFileName : fileName , pathInBundle : "resource/data").data
    }
    
    func setData(#data : JSON) -> Void
    {
        playlist = data
    }
    
    //初始化当前默认场景
    func initScene() -> Void
    {
        for (key : String , subJson : JSON) in playlist
        {
            currentScene = subJson["name"].stringValue
            
            break
        }
    }
    
    //获取当前场景播放列表
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
        
        return _currentScenePlayContentForIndex(index)
    }
    
    //当前播放音频相关数据
    func currentPlayContent () -> Dictionary<String,String>
    {
        let index : Int = currentIndexOfScene
        
        return _currentScenePlayContentForIndex(index)
    }
    
    func prevPlayContent () -> Dictionary<String,String>
    {
        let index : Int = currentIndexOfScene - 1
        
        return _currentScenePlayContentForIndex(index)
    }
    
    //获取当前场景下指定index的音频相关数据
    private func _currentScenePlayContentForIndex(index : Int) -> Dictionary<String,String>
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
    
    //场景列表
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