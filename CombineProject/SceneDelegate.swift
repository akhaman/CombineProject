//
//  SceneDelegate.swift
//  CombineProject
//
//  Created by Руслан Ахмадеев on 05.11.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        guard let windowScene = scene as? UIWindowScene else { return }
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        let navigationController = UINavigationController(navigationBarClass: NavigationBar.self, toolbarClass: nil)
        let viewController = AnimalsAssembly.assemble()
        navigationController.pushViewController(viewController, animated: false)
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }
}

