//
//  AppDelegate.swift
//  rsschool_task10
//
//  Created by dzmitry ilyin on 8/25/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        let rootController = GameState.sharedInstance.gameCondition == .inProgress ? GameViewController() : NewGameViewController()
        let navController = UINavigationController(rootViewController: rootController)
        navController.navigationBar.barTintColor = UIColor(named: "background_black")
        navController.navigationBar.isTranslucent = false
        navController.navigationBar.setValue(true, forKey: "hidesShadow")
        
        window.rootViewController = navController
        window.makeKeyAndVisible()
        self.window = window
                
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
            // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
            // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        print("applicationWillResignActive")
        }

        func applicationDidEnterBackground(_ application: UIApplication) {
            print("applicationDidEnterBackground")
        }

        func applicationWillEnterForeground(_ application: UIApplication) {
            print("applicationWillEnterForeground")
        }

        func applicationDidBecomeActive(_ application: UIApplication) {
            print("applicationDidBecomeActive")
        }

        func applicationWillTerminate(_ application: UIApplication) {
//            UserDefaults.standard.setValue(GameState.sharedInstance, forKey: "gameState")
            print("applicationWillTerminate")
        }

}

