//: Playground - noun: a place where people can play

import UIKit

let frameColor : UIColor = UIColor.whiteColor()

var view : UIView = UIView(frame: CGRectMake(0, 0, 600, 600))
view.backgroundColor = frameColor

//set background image
var backgroundImage : UIImage = UIImage(named: "logo.jpg")!
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

let bottomBackgroundView : UIView = UIView(frame: CGRectMake(0, 480, 600, 160))
bottomBackgroundView.backgroundColor = frameColor
view.addSubview(bottomBackgroundView)

//set label
var title : UILabel = UILabel(frame: CGRectMake(20, 486, 560, 60))
title.text = "起床磨耳朵"
title.font =  UIFont (name: "HelveticaNeue-UltraLight", size: 36)
view.addSubview(title)

var description : UILabel = UILabel(frame: CGRectMake(20, 532, 560, 60))
description.text = "ColorSong"
description.font =  UIFont (name: "HelveticaNeue-UltraLight", size: 28)
description.textColor = UIColor.grayColor()
view.addSubview(description)


//get image
UIGraphicsBeginImageContextWithOptions(CGSizeMake(600.0, 600.0), false, 1.0)

view.layer.renderInContext(UIGraphicsGetCurrentContext())

let image : UIImage = UIGraphicsGetImageFromCurrentImageContext()

UIGraphicsEndImageContext()
