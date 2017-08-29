//
//  AppDelegate.swift
//  IndoorsProj
//
//  Created by macbook air on 27/08/2017.
//  Copyright © 2017 Lytkin Artem. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?



  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
    // Override point for customization after application launch.
    return true
  }
  
  //func application(application: UIApplication, openURL url: NSURL) -> Bool {
  func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
    print("*** I'm in openURL process ***")
    GitHubAPIManager.sharedInstance.processOAuthStep1Response(url: url)
    return true
  }


}

