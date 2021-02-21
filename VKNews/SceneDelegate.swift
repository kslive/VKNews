//
//  SceneDelegate.swift
//  VKNews
//
//  Created by Eugene Kiselev on 20.12.2020.
//

import UIKit
import VK_ios_sdk

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var authService: AuthService!
    
    static func shared() -> SceneDelegate {
        let scene = UIApplication.shared.connectedScenes.first
        let sd: SceneDelegate = (scene?.delegate as? SceneDelegate)!
        return sd
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        authService = AuthService()
        authService.delegate = self
        let authViewController = UIStoryboard(name: String(describing: AuthViewController.self), bundle: nil).instantiateInitialViewController() as? AuthViewController
        window?.rootViewController = authViewController
        window?.makeKeyAndVisible()
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            VKSdk.processOpen(url, fromApplication: UIApplication.OpenURLOptionsKey.sourceApplication.rawValue)
        }
    }
    func sceneDidDisconnect(_ scene: UIScene) { }
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
}

extension SceneDelegate: AuthServiceDelegate {
    func authServiceShootShow(viewController: UIViewController) {
        window?.rootViewController?.present(viewController, animated: true)
    }
    
    func authServiceSignIn() {
        let feedViewController = UIStoryboard(name: String(describing: NewsFeedViewController.self), bundle: nil).instantiateInitialViewController() as! NewsFeedViewController
        let navigationController = UINavigationController(rootViewController: feedViewController)
        window?.rootViewController = navigationController
    }
    
    func authServiceSignInDidFail() {
        
    }
}

