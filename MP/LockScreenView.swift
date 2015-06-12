//
//  LockScreenView.swift
//  生成锁屏界面图片
//
//  Created by bijiabo on 15/6/10.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation
import UIKit

class LockScreenView {
    var image : UIImage = UIImage()
    
    init(imageName : String , title : String , description : String)
    {
        image = _generateImage(view: _generateView(imageName: imageName, title: title, description: description))
    }
    
    private func _generateView (#imageName : String , title : String , description : String) -> UIView
    {
        //设定画框颜色
        let frameColor : UIColor = UIColor.whiteColor()
        
        //设定view尺寸和背景颜色
        var view : UIView = UIView(frame: CGRectMake(0, 0, 600, 600))
        view.backgroundColor = frameColor
        
        //设定照片
        let imageURL : NSURL = NSBundle.mainBundle().URLForResource(imageName, withExtension: "jpg", subdirectory: "resource/image")!
        let imageData : NSData = NSData(contentsOfURL: imageURL)!
        
        var backgroundImage : UIImage = UIImage(data: imageData)!
        let backgroundView : UIImageView = UIImageView(frame: CGRectMake(20, 20, 560, 560))
        backgroundView.image = backgroundImage
        backgroundView.contentMode = UIViewContentMode.ScaleAspectFill
        
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        //设定顶部白条，做出画框效果
        let topView : UIView = UIView(frame: CGRectMake(0, 0, 600, 20))
        topView.backgroundColor = frameColor
        view.addSubview(topView)
        
        //设定底部毛玻璃效果（弃用）
        /*
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight )) as UIVisualEffectView
        visualEffectView.frame = CGRectMake(0, 250, 300, 50)
        
        visualEffectView.alpha = 1
        view.addSubview(visualEffectView)
        */
        
        //设定底部文字背景为白色，做出拍立得效果
        let bottomBackgroundView : UIView = UIView(frame: CGRectMake(0, 480, 600, 120))
        bottomBackgroundView.backgroundColor = frameColor
        view.addSubview(bottomBackgroundView)
        
        //设定文字
        var titleLabel : UILabel = UILabel(frame: CGRectMake(20, 486, 560, 60))
        titleLabel.text = title
        titleLabel.font =  UIFont (name: "HelveticaNeue-UltraLight", size: 36)
        view.addSubview(titleLabel)
        
        var descriptionLabel : UILabel = UILabel(frame: CGRectMake(20, 532, 560, 60))
        descriptionLabel.text = description
        descriptionLabel.font =  UIFont (name: "HelveticaNeue-UltraLight", size: 28)
        descriptionLabel.textColor = UIColor(red:0.31, green:0.32, blue:0.32, alpha:1)
        view.addSubview(descriptionLabel)

        return view
    }
    
    //生成快照图片
    private func _generateImage (#view : UIView) -> UIImage
    {
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(600.0, 600.0), false, 1.0)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}