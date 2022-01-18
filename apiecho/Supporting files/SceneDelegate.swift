//
//  SceneDelegate.swift
//  apiecho
//
//  Created by Veronika Andrianova on 18.01.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appNavigator: AppNavigator?

    func scene(_ scene: UIScene,
               willConnectTo session: UISceneSession,
               options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        
        appNavigator = AppNavigator(window: window!)
        appNavigator?.startFlow()
    }
}
