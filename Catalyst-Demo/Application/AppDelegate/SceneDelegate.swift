//
//  SceneDelegate.swift
//  Catalyst-Demo
//
//  Created by Bliss on 22/1/21.
//

import UIKit
import Combine
import WidgetKit

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    #if targetEnvironment(macCatalyst)
    private let shareItem =
        NSSharingServicePickerToolbarItem(itemIdentifier: .shareEntry)
    #endif
    private var activityItemsConfigurationSubscriber: AnyCancellable?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {


        // Use this method to optionally configure and attach the
        // UIWindow `window` to the provided UIWindowScene `scene`.

        // If using a storyboard, the `window` property will
        // automatically be initialized and attached to the scene.

        // This delegate doesn't imply the connecting scene or session are new
        // (see `application:configurationForConnectingSceneSession` instead).
        NetworkServiceFactory.shared.setUp(baseURL: "https://api.covid19api.com")

        guard let windowScene = (scene as? UIWindowScene) else { return }

        window = UIWindow(windowScene: windowScene)

        let module = HomeModule()
        let detailModule = DetailModule()

        var homeNavigationController = UINavigationController()
        homeNavigationController = UINavigationController(rootViewController: module.view)

        let splitViewController =  PrimarySplitViewController()
        splitViewController.viewControllers = [homeNavigationController, detailModule.view]

        window?.rootViewController = splitViewController
        window?.makeKeyAndVisible()


        #if targetEnvironment(macCatalyst)
        if let titlebar = window?.windowScene?.titlebar {
            titlebar.titleVisibility = .hidden
            titlebar.toolbar = nil
        }
        #endif

        #if targetEnvironment(macCatalyst)
        // 1
        if let scene = scene as? UIWindowScene,
           let titlebar = scene.titlebar {
            // 2
            let toolbar = NSToolbar(identifier: "Toolbar")
            // 3
            titlebar.toolbar = toolbar
            toolbar.delegate = self
            toolbar.allowsUserCustomization = true
            toolbar.autosavesConfiguration = true
            activityItemsConfigurationSubscriber
              = NotificationCenter.default
              .publisher(for: Notification.Name("activityItemsConfigurationDidChange"))
              .receive(on: RunLoop.main)
              .map({
                  $0.userInfo?["SelectedModelKey"]
                    as? UIActivityItemsConfiguration
              })
              .assign(to: \.activityItemsConfiguration,
                      on: shareItem)
        }
        #endif
        WidgetCenter.shared.reloadAllTimelines()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
}

#if targetEnvironment(macCatalyst)
extension NSToolbarItem.Identifier {
    static let favouriteEntry =
        NSToolbarItem.Identifier(rawValue: "FavouriteEntry")
    static let openEntry =
        NSToolbarItem.Identifier(rawValue: "OpenEntry")
    static let shareEntry =
        NSToolbarItem.Identifier(rawValue: "ShareEntry")
}

extension SceneDelegate: NSToolbarDelegate {

    func toolbarAllowedItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.toggleSidebar, .favouriteEntry, .openEntry, .shareEntry, .flexibleSpace]
    }

    func toolbarDefaultItemIdentifiers(_ toolbar: NSToolbar) -> [NSToolbarItem.Identifier] {
        return [.toggleSidebar, .favouriteEntry, .shareEntry]
    }

    func toolbar(_ toolbar: NSToolbar, itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier, willBeInsertedIntoToolbar flag: Bool) -> NSToolbarItem? {
        var item: NSToolbarItem?
        switch itemIdentifier {
        case .favouriteEntry:
            item = NSToolbarItem(itemIdentifier: .favouriteEntry)
            item?.image = UIImage(systemName: "star")
            item?.label = "Favourite"
            item?.toolTip = "Add Favourite"
            item?.target = self
            item?.action = #selector(favEntry)
        case .openEntry:
            item = NSToolbarItem(itemIdentifier: .openEntry)
            item?.image = UIImage(systemName: "safari")
            item?.label = "Web"
            item?.toolTip = "Open Entry in Web"
            item?.target = self
            item?.action = #selector(openEntry)
        case .shareEntry:
            return shareItem
        case .toggleSidebar:
            item = NSToolbarItem(itemIdentifier: itemIdentifier)
        default:
            item = nil
        }
        return item
    }

    // 2.
    @objc private func openEntry() {
        guard

            let splitViewController
                = window?.rootViewController
                as? UISplitViewController,
            let detailViewController
                = splitViewController.viewControllers.last
                as? DetailViewController ??
                (splitViewController.viewControllers.last as? UINavigationController)?.viewControllers.first
                as? DetailViewController else {
            return
        }
        if let url = URL(string: "https://www.google.com/search?q=\(detailViewController.selectedDetail)+covid") {
            UIApplication.shared.open(url)
        }
    }

    @objc private func favEntry() {
    }
}
#endif

extension SceneDelegate {

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard
            let splitedString = URLContexts.first?.url.absoluteString.split(whereSeparator: {$0 == "/"}).map(String.init),
            let item = splitedString.last,
            let splitViewController
                = window?.rootViewController
                as? UISplitViewController,
            let detailViewController
                = splitViewController.viewControllers.last
                as? DetailViewController ??
                (splitViewController.viewControllers.last as? UINavigationController)?.viewControllers.first
                as? DetailViewController else {
            return
        }
        (detailViewController.output as? DetailInput)?.setID(item)
    }
}
