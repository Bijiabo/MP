//
//  NetworkService.swift
//  MP
//
//  Created by bijiabo on 15/6/11.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation

//
//  meteorClient.swift
//  DDP
//
//  Created by bijiabo on 15/5/20.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation

class NetworkService : NSObject {
    
    private var _meteorClient : MeteorClient!
    private var _domain : String = "localhost"
    private var _port : String = "3000"
    
    private var _DDPconnecting : Bool = false
    
    init(domain : String , port : String)
    {
        super.init()
        
        _domain = domain
        _port = port
        
        
        _meteorClient = MeteorClient(DDPVersion: "pre2")
        
        _meteorClient.addSubscription("posts")
        
        _configDDPCnnect(domain: _domain, port: _port)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "_logConnected:",
            name: MeteorClientDidConnectNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "_logDisconnected:",
            name: MeteorClientDidDisconnectNotification,
            object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
            selector: "_connectReady:",
            name: MeteorClientConnectionReadyNotification,
            object: nil)
    }
    
    
    
    private func _configDDPCnnect(#domain : String , port : String ) -> Void {
        var ddp : ObjectiveDDP = ObjectiveDDP(URLString: "ws://\(domain):\(port)/websocket", delegate: self._meteorClient)
        _meteorClient.ddp = ddp
        _meteorClient.ddp.connectWebSocket()
    }
    
    
    internal func _logConnected(note: NSNotification) {
        println("connected to server")
        
        _addSubscription()
        
    }
    
    
    internal func _logDisconnected(note: NSNotification) {
        _DDPconnecting = false
        println("disconnected from server")
    }
    
    internal func _connectReady(note : NSNotification) {
        println("connect ready >>>>")
        
        _DDPconnecting = true
        
        autoLogin(callback: {
            (res,err)->Void in
            NSNotificationCenter.defaultCenter().postNotificationName("DDP_LOGINED", object: nil)
        })
    }
    
    internal func signup(#username : String, password : String , fullname : String , callback: ([NSObject : AnyObject]!,NSError!)->Void )
    {
        _meteorClient.signupWithUsername(username, password: password, fullname: fullname, responseCallback: callback)
    }
    
    
    internal func login(#username : String, password : String ,  callback: ([NSObject : AnyObject]!,NSError!)->Void )
    {
        
        _meteorClient.logonWithUsername(username, password: password, responseCallback: {
            (response,error) -> Void in
            
            if error == nil
            {
                NSUserDefaults.standardUserDefaults().setObject(self._meteorClient.sessionToken , forKey: "Token")
                
            }
            
            callback(response,error)
        })
        //meteorClient.logonWithSessionToken("Rnw1JQqUS4v4F7vjgwV8EUbSFEizFxDB_RXR-G-i9NY")
        
    }
    
    internal func autoLogin(callback : ([NSObject : AnyObject]!,NSError!)->Void = {(res,error)->Void in  }  ) -> Void
    {
        if let token : String = NSUserDefaults.standardUserDefaults().stringForKey("Token")
        {
            let tD : NSDictionary = ["resume" : token]
            _meteorClient.logonWithUserParameters( tD as [NSObject : AnyObject], responseCallback: callback)
        }
    }
    
    private func _addSubscription() -> Void
    {
        _meteorClient.addSubscription("userPlayLists")
        _meteorClient.addSubscription("userModes")
    }
    
    //  获取模式下所有数据
    internal func getAllPlayListForMode(#mode : String, callback : ([NSObject : AnyObject]!,NSError!)->Void ) -> Void
    {
        if _DDPconnecting
        {
            _meteorClient.callMethodName("getAllPlayListForMode", parameters: [mode], responseCallback: callback)
        }
    }
    
    //  获取模式下用户播放列表
    internal func getPlayList(#mode : String, callback : ([NSObject : AnyObject]!,NSError!)->Void ) -> Void
    {
        if _DDPconnecting
        {
            _meteorClient.callMethodName("getPlayList", parameters: [mode], responseCallback: callback)
        }
    }
    
    //  获取模式列表
    internal func getModeList(callback : ([NSObject : AnyObject]!,NSError!)->Void ) -> Void
    {
        if _meteorClient.authState == AuthState.LoggedIn && _DDPconnecting
        {
            _meteorClient.callMethodName("getModeList", parameters: ["xxx"], responseCallback: callback)
        }
        else
        {
            println("did not logged in")
        }
    }
    
    //  添加新模式
    internal func addNewMode(#mode : String, callback : ([NSObject : AnyObject]!,NSError!)->Void ) -> Void
    {
        if _DDPconnecting
        {
            _meteorClient.callMethodName("addModeByUser", parameters: [mode], responseCallback: callback)
        }
    }
    
    //  删除模式
    internal func removeNewMode(#modeId : String, callback : ([NSObject : AnyObject]!,NSError!)->Void ) -> Void
    {
        if _DDPconnecting
        {
            _meteorClient.callMethodName("removeModeByUser", parameters: [modeId], responseCallback: callback)
        }
    }
    
    //  删除用户模式下播放列表
    internal func removePlayListItemInMode(#modeId : String, playListItemId : String , callback : ([NSObject : AnyObject]!,NSError!)->Void ) -> Void
    {
        if _DDPconnecting
        {
            _meteorClient.callMethodName("removePlayListItemInModeByUser", parameters: [modeId, playListItemId], responseCallback: callback)
        }
    }
    
    //  添加播放列表元素
    internal func addPlayListItem (#mode : String , playItemId : String ,  callback :  ([NSObject : AnyObject]!,NSError!)->Void) -> Void
    {
        if _DDPconnecting
        {
            _meteorClient.callMethodName("addNewAudioForModeByUser", parameters: [mode, playItemId], responseCallback: callback)
        }
    }
    
    //  删除播放列表元素
    internal func removePlayListItem (#mode : String , playItemId : String ,  callback :  ([NSObject : AnyObject]!,NSError!)->Void) -> Void
    {
        if _DDPconnecting
        {
            _meteorClient.callMethodName("removePlayListItemInModeByUser", parameters: [mode, playItemId], responseCallback: callback)
        }
    }
    
    internal func loggedIn() -> Bool
    {
        return _meteorClient.authState == AuthState.LoggedIn ? true : false
    }
    
}