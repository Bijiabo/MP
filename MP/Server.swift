//
//  order.swift
//  MP
//
//  Created by bijiabo on 15/6/2.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//



import Foundation

class Server : ServerProtocol
{
    var playlist : [Dictionary<String,AnyObject>] = [Dictionary<String,AnyObject>]()
    var scenelist : Array<String> = Array<String>()
    var currentScene : String = ""
    var playInfo : playInformationProtocol
    {
        get{
            for var i=0 ; i<playlist.count ; i++
            {
                if playlist[i]["name"] as! String == currentScene
                {
                    if let playlistItem = playlist[i]["list"] as? Array<AnyObject>
                    {
                        let item: AnyObject = playlistItem[0]
                        
                        class info : playInformationProtocol
                        {
                            @objc var id : String = item["id"] as! String
                            @objc var audioName : String = item["name"] as! String
                            @objc var tag : String = item["tag"] as! String
                            @objc var description : String = ""
                            
                            @objc var like : Bool = false
                            @objc var dislike : Bool = false
                            
                            @objc var playing : Bool = false
                            @objc var localUrl : String = ""
                            
                            @objc var scene : String = currentScene
                            @objc var scenelist : Array<String> = []
                        }
                        
                        return info()
                    }
                }
            }
            
            return self.playInfo
        }
    }
    
    //MARK:
    //MARK: protocol func
    func switchToScene(targetScene : String)
    {
        for var i=0 ; i<scenelist.count ; i++
        {
            if scenelist[i] == targetScene && targetScene != currentScene
            {
                currentScene = targetScene
            }
        }
    }
    
    func next()
    {
        
    }
    
    func previous()
    {
        
    }
    //MARK:
    
    //当前音频是否再次播放一遍
    var playOnceAgain : Bool = false
    
    //当前场景音频播放index
    /*
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
    */
    
    init()
    {
        setData(dataFileName : "0.json" )
        
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
    func fetchJsonData(data : JSON) -> [Dictionary<String,AnyObject>]
    {
        var result : [Dictionary<String,AnyObject>] = [Dictionary<String,AnyObject>]()
        
        for (index : String, subJson : JSON) in data
        {
            result.append(subJson.dictionaryObject!)
        }
        
        return result
    }
    
    
    func setData(dataFileName fileName : String ) -> Void
    {
        println("fileName : \(fileName)")
        
        playlist = fetchJsonData( dataLoader(dataFileName : fileName , pathInBundle : "resource/data").data )
        
        
        checkLocalMediaAndDownloads()
    }
    
    func setData(#data : JSON) -> Void
    {
        playlist = fetchJsonData( data )
        
        checkLocalMediaAndDownloads()
    }
    
    func setDataAndRefreshServer(dataFileName fileName : String ) -> Void
    {
        setData(dataFileName: fileName)
        
        initScene()
    }
    
    func checkLocalMediaAndDownloads () -> Void
    {
        var urls : Array<String> = Array<String>()
        
        for var i = 0 ; i < playlist.count ; i++
        {
            for (key : String , value : AnyObject) in playlist[i]
            {
                if let remoteURLArray =  (value as! Dictionary<String,AnyObject>)["remoteURL"] as? Array<String>
                {
                    if remoteURLArray.count > 0
                    {
                        let url : String = remoteURLArray[0]
                        if url != ""
                        {
                            urls.append(url)
                        }
                    }
                }
            }
        }
        
        
        
        
        //let httpDownloader : HttpDownloader = HttpDownloader(queue: urls, cacheSubDirectory: "test")
        //httpDownloader.startDownloadQueueAsync()
    }
    
    //初始化当前默认场景
    func initScene() -> Void
    {
        for var i = 0 ; i < playlist.count ; i++
        {
            for (key : String , value : AnyObject) in playlist[i]
            {
                if let playlistItem : Dictionary<String , AnyObject> = value as? Dictionary<String, AnyObject>
                {
                    currentScene = playlistItem["name"] as! String
                }
                
            }
        }
        
    }
    /*
    //获取当前场景播放列表
    func getCurrentScenePlaylist() -> [Dictionary<String,String>]
    {
        var list : [Dictionary<String,String>] = [Dictionary<String,String>]()
        
        println(playlist)
        
        for (key : String , subJson : JSON) in playlist
        {
            if subJson["name"].stringValue == currentScene
            {
                for (key1 : String , subJson1 : JSON) in subJson["list"]
                {
                    list.append([
                        "name" : subJson1["name"].stringValue,
                        "url": subJson1["localURI"].stringValue,
                        "tag": subJson1["tag"].stringValue,
                        "id" : subJson1["id"].stringValue
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
    */
}