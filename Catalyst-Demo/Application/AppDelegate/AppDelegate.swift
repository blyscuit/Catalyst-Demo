//
//  AppDelegate.swift
//  Catalyst-Demo
//
//  Created by Bliss on 20/1/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        if #available(iOS 13.0, *) {
            // In iOS 13 setup is done in SceneDelegate
        } else {
            NetworkServiceFactory.shared.setUp(baseURL: "https://api.covid19api.com")

            window = UIWindow(frame: UIScreen.main.bounds)

            let module = HomeModule()
            let detailModule = DetailModule()

            var detailNavigationController = UINavigationController()
            detailNavigationController = UINavigationController(rootViewController: detailModule.view)

            let splitViewController =  PrimarySplitViewController()
            splitViewController.viewControllers = [module.view, detailNavigationController]

            window?.rootViewController = splitViewController
            window?.makeKeyAndVisible()
        }


        #if targetEnvironment(macCatalyst)
        if let titlebar = window?.windowScene?.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = nil
        }
        #endif

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    override func buildMenu(with builder: UIMenuBuilder) {
        guard builder.system == .main else { return }

        let refreshCommand = UIKeyCommand(
            title: "Refresh",
            action: #selector(HomeViewController.refresh(_:)),
            input: "R",
            modifierFlags: .command
        )

        let searchCommand = UIKeyCommand(
            title: "Search",
            image: UIImage(systemName: "magnifyingglass"),
            action: #selector(HomeViewController.beginSearch),
            input: "F",
            modifierFlags: .command
        )

        let menu = UIMenu(
            title: "",
            image: nil,
            identifier: UIMenu.Identifier("Control"),
            options: .displayInline,
            children: [refreshCommand, searchCommand]
        )

        builder.insertChild(menu, atStartOfMenu: .file)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
