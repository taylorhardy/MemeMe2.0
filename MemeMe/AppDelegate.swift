//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Hardy, Taylor J on 5/20/16.
//  Copyright © 2016 Hardy, Taylor J. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var memes = [Meme]()

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }
}

