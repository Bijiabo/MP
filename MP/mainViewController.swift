//
//  ViewController.swift
//  MP
//
//  Created by JGTM on 15/6/1.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import UIKit

class mainViewController: UIViewController, UITabBarDelegate
{
    @IBOutlet weak var tabBar: UITabBar!
    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet var mainNavigationBar: UINavigationBar!
    @IBOutlet var navigationBarTitle: UINavigationItem!
    @IBOutlet var audioTag: UILabel!
    @IBOutlet var audioName: UILabel!
    
    
    var delegate : AppDelegate!
    
    var server : Server!
    
    var tabbarLoaded : Bool = false
    
    var model : Dictionary<String,AnyObject> = Dictionary<String,AnyObject>()
    {
        didSet
        {
            refreshView()
        }
    }
    
    override func viewDidLoad()
    {
        
        super.viewDidLoad()
        
        tabBar.delegate = self
        
        refreshView()
        
        //update audio info view
        
        //_updateAudioInfoView(playlist[0]["name"]!, tag: playlist[0]["tag"]!)
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(animated)
        
//        refreshView()
    }
    

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
    }
    
    func _refreshNavigationBar (#navigationBar : UINavigationBar) -> Void
    {

        navigationBar.translucent = true
        navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        
        navigationBar.titleTextAttributes = [
            NSForegroundColorAttributeName : UIColor.whiteColor()
        ]
        navigationBar.shadowImage = UIImage()

    }

    func _refreshTabBar (#tabbar : UITabBar , scenelist : Array<String> , currentScene : String) -> Void
    {
        if self.tabBar == nil || tabbarLoaded {return}
        
        tabbarLoaded = true
        
        var currentSceneTag : Int = 0
        
        var tabbarItemsCache : [UITabBarItem] = []
        
        for var i=0; i<scenelist.count; i++
        {
            let sceneItemKeyString : String = scenelist[i]
            let sceneItemNameString : String = scenelist[i]
            
            if sceneItemKeyString == currentScene
            {
                currentSceneTag = i
            }
            
            let item = UITabBarItem(title: sceneItemNameString, image: UIImage(named: "Mode-\(sceneItemKeyString)"), tag: i)
            
            tabbarItemsCache.append(item)
        }
        
        tabbar.setItems(tabbarItemsCache, animated: true)
        
        for barItem in tabbar.items as! [UITabBarItem]
        {
            if barItem.tag == currentSceneTag
            {
                tabbar.selectedItem = barItem
                break
            }
        }
        
    }
    
    private func _refreshBackgroundImageView () -> Void
    {
        if backgroundImageView == nil {return}
        let resourceURL : NSURL = NSBundle.mainBundle().resourceURL!.URLByAppendingPathComponent("resource/image", isDirectory: true)
      
        let sceneKey : String = server.currentScene
        
        let imagePath : NSURL = resourceURL.URLByAppendingPathComponent("\(sceneKey).jpg")

        backgroundImageView.image = UIImage(contentsOfFile: imagePath.relativePath!)
    }
    
    func _updateTitle () -> Void
    {
        if self.navigationBarTitle == nil {return}

        let sceneName : String = server.currentScene
        
        navigationBarTitle.title = "\(sceneName)磨耳朵"
    }
    
    @IBAction func togglePlayPause(sender: AnyObject)
    {
      delegate.togglePlayPause()
    }
    
    func _refreshPlayPauseButtonView (#button : UIButton  , playing : Bool) -> Void
    {
        var playPauseButtonImageName : String = "playButton"
        
        if playing
        {
            playPauseButtonImageName = "pauseButton"
        }
      
      button.setImage(UIImage(named: playPauseButtonImageName), forState: UIControlState.Normal)
      button.setImage(UIImage(named: "\(playPauseButtonImageName)_active"), forState: UIControlState.Highlighted)
      button.setImage(UIImage(named: "\(playPauseButtonImageName)_active"), forState: UIControlState.Selected)
    }
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!)
    {
        let selectedTabBarItem : UITabBarItem = item as UITabBarItem
        
        let selectedItemTag : Int = selectedTabBarItem.tag
        
        selectedTabBar(tag : selectedItemTag)
        
    }
    
    func selectedTabBar (#tag : Int) -> Void
    {
        let scene : String = server.sceneList()[tag]
        
        delegate.switchScene(targetScene: scene)
    }
    
    func _refreshAudioInfoView (#name : String , tag : String ) -> Void
    {
        if audioName == nil || audioTag == nil {return}
        
        audioName.text = name
        audioTag.text = tag
    }
    
    func refreshView ()
    {

        if self.mainNavigationBar != nil
        {
            _refreshNavigationBar(navigationBar: mainNavigationBar)
        }
        
        _updateTitle()

        if self.tabBar != nil
        {
            _refreshTabBar(tabbar: tabBar, scenelist: model["scenelist"] as! Array<String>, currentScene: model["currentScene"] as! String)
        }

        if self.playPauseButton != nil
        {
            _refreshPlayPauseButtonView(button: self.playPauseButton, playing: model["playing"] as! Bool)
        }
        
        _refreshAudioInfoView(name: model["name"] as! String, tag: model["tag"] as! String)

        _refreshBackgroundImageView()

    }
    
    override func preferredStatusBarStyle() -> UIStatusBarStyle
    {
        return UIStatusBarStyle.LightContent
    }
    
    
}

