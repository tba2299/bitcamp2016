//
//  AppDelegate.swift
//  bitcamp2016
//
//  Created by Nick LoBue on 4/8/16.
//  Copyright © 2016 TNAdevs. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        SPTAuth.defaultInstance().clientID = "ce2383b32d8442a28f406ad2acdf747b"
        SPTAuth.defaultInstance().redirectURL = NSURL(string: "bitcamp2016-spotify-login://returnafterlogin")!
        SPTAuth.defaultInstance().requestedScopes = [SPTAuthStreamingScope]
        // Construct a login URL and open it
        let loginURL: NSURL = SPTAuth.defaultInstance().loginURL
        // Opening a URL in Safari close to application launch may trigger
        // an iOS bug, so we wait a bit before doing so.
        application.performSelector(#selector(UIApplication.openURL(_:)), withObject: loginURL, afterDelay: 0.1)
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

