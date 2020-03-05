//
//  AppDelegate.swift
//  HeaderFooterRefreshView
//
//  Created by Meggapixxel on 03/04/2020.
//  Copyright (c) 2020 Meggapixxel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window
        window.rootViewController = UINavigationController(rootViewController: SelectionVC())
        window.makeKeyAndVisible()
        
        return true
    }
    
}

