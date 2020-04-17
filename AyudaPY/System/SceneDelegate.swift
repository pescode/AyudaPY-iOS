//
//  SceneDelegate.swift
//  AyudaPY
//
//  Created by Victor on 4/9/20.
//  Copyright © 2020 VCORVA. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appStore = AppStore()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            let contentView = ContentView()
                .environment(\.managedObjectContext, managedObjectContext)
                .environmentObject(appStore)
            
            window.rootViewController = UIHostingController(rootView: contentView)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }


}

