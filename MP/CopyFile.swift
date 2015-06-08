//
//  CopyFile.swift
//  MP
//
//  Created by bijiabo on 15/6/7.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation

class CopyFile {
    init()
    {
        let cachePath : String = NSSearchPathForDirectoriesInDomains(.CachesDirectory , .UserDomainMask, true)[0] as! String
        
        let targetPath : String = cachePath + "/resource/"
        
        let bundleResourceDirectoryURL : NSURL! = NSBundle.mainBundle().resourceURL?.URLByAppendingPathComponent("resource")
        
        copyFiles(fromeURL: bundleResourceDirectoryURL, targetPath: targetPath)
    }
    
    func copyFiles(#fromeURL : NSURL  , targetPath : String) -> Void
    {
        let fileManager : NSFileManager = NSFileManager.defaultManager()
        
        var isDir : ObjCBool = true
        var isNotDir : ObjCBool = false
        
        
        let fileExists : Bool = fileManager.fileExistsAtPath(targetPath)
        
        if fileExists
        {
            let pathlist : [AnyObject]? = fileManager.contentsOfDirectoryAtURL( fromeURL  , includingPropertiesForKeys: nil, options: nil, error: nil)
            
            if (pathlist != nil)
            {
                //is a directory
                
                for path in pathlist!
                {
                    let pathLastPathComponent : String = path.lastPathComponent
                    
                    let URLForPath : NSURL = NSURL(fileURLWithPath: targetPath + pathLastPathComponent)!
                    
                    let pathExists : Bool = fileManager.fileExistsAtPath(URLForPath.relativePath!)
                    
                    if pathExists == false
                    {
                        //文件不存在，拷贝！
                        fileManager.copyItemAtURL(path as! NSURL, toURL: NSURL(fileURLWithPath: targetPath + "/" + pathLastPathComponent)!, error: nil)
                    }
                    else
                    {
                        //文件存在，检查一下里面
                        copyFiles(fromeURL: path as! NSURL, targetPath: targetPath + "/" + pathLastPathComponent + "/")
                    }
                }
            }
            
        }
        else
        {
            fileManager.copyItemAtURL(fromeURL, toURL: NSURL(fileURLWithPath: targetPath)!, error: nil)
        }
    }
}