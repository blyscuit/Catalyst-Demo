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

        NetworkServiceFactory.shared.setUp(baseURL: "https://api.covid19api.com")

        window = UIWindow(frame: UIScreen.main.bounds)

        let module = HomeModule()
        let navigationController = UINavigationController(rootViewController: module.view)

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()


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

        let menu = UIMenu(
            title: "",
            image: nil,
            identifier: UIMenu.Identifier("Control"),
            options: .displayInline,
            children: [refreshCommand]
        )

        builder.insertChild(menu, atStartOfMenu: .file)
    }
}

