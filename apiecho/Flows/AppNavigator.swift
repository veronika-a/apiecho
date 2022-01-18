//
//  AppNavigator.swift
//  apiecho
//
//  Created by Veronika Andrianova on 18.01.2022.
//

import Foundation
import UIKit

final class AppNavigator {

    private let window: UIWindow

    init(window: UIWindow) {
        self.window = window
    }

    func startFlow() {
        let userIsLoggedIn = true

        if userIsLoggedIn {
            let service = NetworkService()
            let controller = MainVC(mainViewModel: MainViewModel(model: MainModel(service: service)))

            let navigationController = UINavigationController.init(rootViewController: controller)
            navigationController.navigationBar.isHidden = true
            window.rootViewController = navigationController
            window.makeKeyAndVisible()
        } else {
            // создаем координатор для этого кейса и идем по нему, например, LoginCoordinator
        }
    }
}
