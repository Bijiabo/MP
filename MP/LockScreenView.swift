//
//  LockScreenView.swift
//  MP
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
        let frameColor : UIColor = UIColor.whiteColor()
        
        var view : UIView = UIView(frame: CGRectMake(0, 0, 600, 600))
        view.backgroundColor = frameColor
        
        //set background image
        let imageURL : NSURL = NSBundle.mainBundle().URLForResource(imageName, withExtension: "jpg", subdirectory: "resource/image")!
        let imageData : NSData = NSData(contentsOfURL: imageURL)!
        
        var backgroundImage : UIImage = UIImage(data: imageData)!
        let backgroundView : UIImageView = UIImageView(frame: CGRectMake(20, 20, 560, 560))
        backgroundView.image = backgroundImage
        backgroundView.contentMode = UIViewContentMode.ScaleAspectFill
        
        view.addSubview(backgroundView)
        view.sendSubviewToBack(backgroundView)
        
        //fix top white view
        let topView : UIView = UIView(frame: CGRectMake(0, 0, 600, 20))
        topView.backgroundColor = frameColor
        view.addSubview(topView)
        
        //set label background
        /*
        var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .ExtraLight )) as UIVisualEffectView
        visualEffectView.frame = CGRectMake(0, 250, 300, 50)
        
        visualEffectView.alpha = 1
        view.addSubview(visualEffectView)
        */
        
        let bottomBackgroundView : UIView = UIView(frame: CGRectMake(0, 480, 600, 120))
        bottomBackgroundView.backgroundColor = frameColor
        view.addSubview(bottomBackgroundView)
        
        //set label
        var titleLabel : UILabel = UILabel(frame: CGRectMake(20, 486, 560, 60))
        titleLabel.text = title
        titleLabel.font =  UIFont (name: "HelveticaNeue-UltraLight", size: 36)
        view.addSubview(titleLabel)
        
        var descriptionLabel : UILabel = UILabel(frame: CGRectMake(20, 532, 560, 60))
        descriptionLabel.text = description
        descriptionLabel.font =  UIFont (name: "HelveticaNeue-UltraLight", size: 28)
        descriptionLabel.textColor = UIColor.grayColor()
        view.addSubview(descriptionLabel)

        return view
    }
    
    private func _generateImage (#view : UIView) -> UIImage
    {
        //get image
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(600.0, 600.0), false, 1.0)
        
        view.layer.renderInContext(UIGraphicsGetCurrentContext())
        
        let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return image
    }
}