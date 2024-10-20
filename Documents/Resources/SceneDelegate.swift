

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        let tabBar = UITabBarController()
        
//        if PasswordManagerService().startPassword() == false{
//            let passwordVC = PasswordViewController()
//            let navigationVC = UINavigationController(rootViewController: passwordVC)
//            
//            window.rootViewController = navigationVC
//        }
//        else {
//            window.rootViewController = tabBar
//        }
        
        window.rootViewController = tabBar
        
        tabBar.tabBar.backgroundColor = UIColor.systemGray5
        
        let password = PasswordViewController()
        let settings = SettingsViewController()
        
        password.tabBarItem = UITabBarItem(title: "Docs", image: UIImage(systemName: "doc"), tag: 0)
        settings.tabBarItem = UITabBarItem(title: "Settings", image: UIImage(systemName: "gear"), tag: 1)
        
        let controllers = [password,
                           settings]
        
        tabBar.viewControllers = controllers.map {
            UINavigationController(rootViewController: $0)
        }
            
//        let passwordVC = PasswordViewController()
//        passwordVC.modalPresentationStyle = .fullScreen
////        
//        DispatchQueue.global().async {
//            DispatchQueue.main.async {
//                self.window?.rootViewController?.present(passwordVC, animated: false)
//                                                         }
//                                                         }
        
        window.makeKeyAndVisible()
        self.window = window
        
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

