//
//  AppDelegate.swift
//  Demo-Shop-Swift
//
//  Created by MobCast Innovations on 06/03/18.
//  Copyright © 2018 MobCast Innovations. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.setupRootVC()
        self.refreshDemoData()
        return true
    }
    private func refreshDemoData() {
        ATAppManager.sharedManager().refreshDemoData()
    }
    func setupRootVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let categoriesTilesVC = storyboard.instantiateViewController(withIdentifier: "ATTilesVC") as! ATTilesVC
        categoriesTilesVC.tabBarItem.title = "Categories"
        categoriesTilesVC.tabBarItem.image = #imageLiteral(resourceName: "Categories")
        categoriesTilesVC.navigationItem.title = "Categories"
        categoriesTilesVC.setDataParameters(.categories, parenCategoryId: nil, parentRankingName: nil)
        
        let productsByRankingTIlesVC = storyboard.instantiateViewController(withIdentifier: "ATTilesVC") as! ATTilesVC
        productsByRankingTIlesVC.tabBarItem.title = "Rankings"
        productsByRankingTIlesVC.tabBarItem.image = #imageLiteral(resourceName: "Rankings")
        productsByRankingTIlesVC.navigationItem.title = "Rankings"
        productsByRankingTIlesVC.setDataParameters(.rankings, parenCategoryId: nil, parentRankingName: nil)
        
        let tabVC = UITabBarController()
        tabVC.viewControllers = [UINavigationController.init(rootViewController: categoriesTilesVC),UINavigationController.init(rootViewController: productsByRankingTIlesVC)]
        self.window?.rootViewController = tabVC
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}
