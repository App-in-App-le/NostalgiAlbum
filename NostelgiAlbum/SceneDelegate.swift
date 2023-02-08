import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
//        let window = UIWindow(frame: UIScreen.main.bounds)
//        let viewController = HomeScreenViewController()
//        window.rootViewController = viewController
//        //window.makeKeyAndVisible()
    }

    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        //window?.rootViewController = HomeScreenViewController()
//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let vc : UIViewController = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController") as UIViewController
//        window?.rootViewController = vc
//        let url = URLContexts.first?.url
//        if(url?.scheme == "file" && url?.pathExtension == "nost")
//        {
//            print("urlpath",url!.path)
//            guard let homeScreenViewController = window?.rootViewController as? HomeScreenViewController else { return }
//            homeScreenViewController.pushShareView(path: url!)
//        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController")
        let navigationController = UINavigationController(rootViewController: vc)
        window?.rootViewController = vc
        window?.rootViewController = navigationController
        let url = URLContexts.first?.url
        if(url?.scheme == "file" && url?.pathExtension == "nost")
        {
            print("urlpath",url!.path)
            guard let homeScreenViewController = navigationController.viewControllers.first as? HomeScreenViewController else { return }
            homeScreenViewController.pushShareView(path: url!)
        }


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

