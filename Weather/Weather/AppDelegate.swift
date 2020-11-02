//
//  AppDelegate.swift
//  Weather
//
//  Created by Tianid on 27.10.2020.
//  Copyright © 2020 Tianid. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        DispatchQueue.global(qos: .userInteractive).async {
            ModelExtractor.shared.makeCityList()
        }
        // Override point for customization after application launch.
        return true
    }
}

