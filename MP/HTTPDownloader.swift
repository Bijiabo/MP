//
//  HttpDownloader.swift
//  downloadTest
//
//  Created by bijiabo on 15/6/13.
//  Copyright (c) 2015年 JYLabs. All rights reserved.
//

import Foundation

class HttpDownloader {
    
    var downloadQueue : Array<String> = Array<String>()
    var directoryInCache : String = "download"
    
    init(queue : Array<String> , cacheSubDirectory : String)
    {
        downloadQueue = queue
        directoryInCache = cacheSubDirectory
    }
    
    /*
    class func loadFileSync(url: NSURL, directoryInCache : String, completion:(path:String, error:NSError!) -> Void)
    {
    //let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
    
    let CacheUrl = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first as! NSURL
    
    let parentDirectory = CacheUrl.URLByAppendingPathComponent(directoryInCache)
    
    //若父文件夹不存在，则创建
    var isDir : ObjCBool = true
    if NSFileManager.defaultManager().fileExistsAtPath(parentDirectory.relativePath!, isDirectory: &isDir)
    {
    NSFileManager.defaultManager().createDirectoryAtURL(parentDirectory, withIntermediateDirectories: true, attributes: [NSFileProtectionKey : NSFileProtectionNone], error: nil)
    }
    
    let destinationUrl = parentDirectory.URLByAppendingPathComponent(url.lastPathComponent!)
    
    if NSFileManager().fileExistsAtPath(destinationUrl.path!) {
    
    println("file already exists [\(destinationUrl.path!)]")
    completion(path: destinationUrl.path!, error:nil)
    
    }
    else if let dataFromURL = NSData(contentsOfURL: url)
    {
    if dataFromURL.writeToURL(destinationUrl, atomically: true)
    {
    println("file saved [\(destinationUrl.path!)]")
    completion(path: destinationUrl.path!, error:nil)
    }
    else
    {
    println("error saving file")
    let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
    completion(path: destinationUrl.path!, error:error)
    }
    }
    else
    {
    let error = NSError(domain:"Error downloading file", code:1002, userInfo:nil)
    completion(path: destinationUrl.path!, error:error)
    }
    }
    */
    
    //异步下载单个文件
    func loadFileAsync(url: NSURL, directoryInCache : String , completion:(path:String, error:NSError!) -> Void)
    {
        //let documentsUrl =  NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first as! NSURL
        
        let CacheUrl = NSFileManager.defaultManager().URLsForDirectory(.CachesDirectory, inDomains: .UserDomainMask).first as! NSURL
        
        let parentDirectory = CacheUrl.URLByAppendingPathComponent(directoryInCache)
        
        //若父文件夹不存在，则创建
        var isDir : ObjCBool = true
        if NSFileManager.defaultManager().fileExistsAtPath(parentDirectory.relativePath!, isDirectory: &isDir) == false
        {
            var error : NSError?
            
            NSFileManager.defaultManager().createDirectoryAtURL(parentDirectory, withIntermediateDirectories: true, attributes: [NSFileProtectionKey : NSFileProtectionNone], error: &error)
            
            println(error)
        }
        
        let destinationUrl = parentDirectory.URLByAppendingPathComponent(url.lastPathComponent!)
        
        if NSFileManager().fileExistsAtPath(destinationUrl.path!)
        {
            completion(path: destinationUrl.path!, error:nil)
        }
        else
        {
            
            let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
            let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
            let request = NSMutableURLRequest(URL: url)
            
            request.HTTPMethod = "GET"
            
            let task = session.dataTaskWithRequest(request, completionHandler:
                {
                    (data: NSData!, response: NSURLResponse!, error: NSError!) -> Void in
                    
                    if (error == nil)
                    {
                        if let response = response as? NSHTTPURLResponse
                        {
                            
                            if response.statusCode == 200
                            {
                                if data.writeToURL(destinationUrl, atomically: true)
                                {
                                    //remove file protection
                                    var fileManagerError : NSError?
                                    
                                    let attributes : [NSObject : AnyObject] = [NSFileProtectionKey : NSFileProtectionNone]
                                    
                                    NSFileManager.defaultManager().setAttributes(attributes, ofItemAtPath: destinationUrl.relativePath!, error: &fileManagerError)
                                    
                                    if fileManagerError != nil
                                    {
                                        println(fileManagerError)
                                    }
                                    
                                    completion(path: destinationUrl.path!, error:error)
                                    
                                }
                                else
                                {
                                    println("error saving file")
                                    let error = NSError(domain:"Error saving file", code:1001, userInfo:nil)
                                    completion(path: destinationUrl.path!, error:error)
                                }
                            }
                        }
                    }
                    else
                    {
                        println("Failure: \(error.localizedDescription)");
                        completion(path: destinationUrl.path!, error:error)
                        
                    }
            })
            
            task.resume()
        }
    }
    
    func startDownloadQueueAsync()
    {
        if downloadQueue.count == 0 {return}
        
        let url : NSURL = NSURL(string: downloadQueue[0])!
        
        loadFileAsync(url, directoryInCache: directoryInCache , completion:{(path:String, error:NSError!) in
            
            self.downloadQueue.removeAtIndex(0)
            
            self.startDownloadQueueAsync()
        })
    }
    
    
    
}