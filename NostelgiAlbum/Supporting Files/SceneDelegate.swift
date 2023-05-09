import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    /*
     .nost파일을 통해 앱을 열 때 호출되는 함수
     iOS 13이상 적용
     */
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        nostFileRemove()
        //Main.storyboard set
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Main.storyboard의 HomeScreenViewController객체를 가져옴
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController")
        //UINavigationController의 rootViewController를 HomeScreenViewController로 지정
        let navigationController = UINavigationController(rootViewController: vc)
        //rootViewControlelr에 객체 값 할당
        window?.rootViewController = vc
        window?.rootViewController = navigationController
        //NostelgiAlbum을 여는 경로가 .nost file일 때
        let url = URLContexts.first?.url
        if(url?.scheme == "file" && url?.pathExtension == "nost")
        {
            //navigationController.viewControllers.first == HomeScreenViewController
            guard let homeScreenViewController = navigationController.viewControllers.first as? HomeScreenViewController else { return }
            //HomeScreenViewController의 pushShareView 동작(파일 URL을 같이 넣어줌)
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

