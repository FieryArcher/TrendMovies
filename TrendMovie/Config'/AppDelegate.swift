//
//  AppDelegate.swift
//  TrendMovie
//
//  Created by Nurlan Darzhanov on 17.10.2024.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        window?.rootViewController = UINavigationController(rootViewController: MovieCatalogViewController())
        window?.makeKeyAndVisible()
        
        return true
    }

}

