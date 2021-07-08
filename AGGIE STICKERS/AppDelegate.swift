//
//  AppDelegate.swift
//  AGGIE STICKERS
//
//  Created by Dheeraj Chauhan on 29/11/20.
//  Copyright © 2020 Dheeraj Chauhan. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?

    static func shared() -> AppDelegate {
           return UIApplication.shared.delegate as! AppDelegate
       }
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        IQKeyboardManager.shared.enable = true
        return true
    }

    
    
    func showLandingPageNavigatonCntr() {
        let storyboard = UIStoryboard(name: kMainStoryboardIdentifier, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "homeNavigation")
        window?.rootViewController = vc
    }
    


}

