import UIKit
import Dispatch
import os.log
//import KakaoSDKAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
//        if connectionOptions.urlContexts.first?.url != nil {
//            let urlinfo = connectionOptions.urlContexts.first?.url
//            os_log("찹모찌")
//        }
        os_log("확인용")
        guard let _ = (scene as? UIWindowScene) else { return }

//        if connectionOptions.urlContexts.first?.url != nil {
//            os_log("왜")
//            self.scene(scene, openURLContexts: connectionOptions.urlContexts)
//        } else {
//            os_log("안돼")
//        }
        if connectionOptions.urlContexts.count > 0 {
            os_log("이거 맞아?")
        } else {
            os_log("아닌듯요")
        }
//        if(connectionOptions.URLContexts.count > 0){
//
//            UIOpenURLContext* urlContext = connectionOptions.URLContexts.anyObject;
//
//            // 바로 처리해주면, 또 안되네, 조금 기다렸다가 처리하라고 시키자.
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                UIApplication* application = [UIApplication sharedApplication];
//                [application.delegate application:application openURL:urlContext.URL options:@{}];
//            });
//        }

    }
    /*
     .nost파일을 통해 앱을 열 때 호출되는 함수
     iOS 13이상 적용
     */
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        os_log("찹모찌2", type: .default)
        nostFileRemove()
        os_log("찹모찌3", type: .default)
        //Main.storyboard set
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Main.storyboard의 HomeScreenViewController객체를 가져옴
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController")
        //UINavigationController의 rootViewController를 HomeScreenViewController로 지정
        let navigationController = UINavigationController(rootViewController: vc)
        //rootViewControlelr에 객체 값 할당
        window?.rootViewController = vc
        window?.rootViewController = navigationController
        os_log("찹모찌4", type: .default)

        //NostelgiAlbum을 여는 경로가 .nost file일 때
        var url = URLContexts.first?.url
        print(url!.path)
//        print("test",URLContexts)
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let testURL = documentDirectory.appendingPathComponent("test.nost")
        let string = "test"
        let txtURL = documentDirectory.appendingPathComponent("\(string).txt")
        print("txtURL",txtURL)
        do  {
            try string.write(to: txtURL, atomically: true, encoding: .utf8)
        } catch let error {
            print("error")
            //            os_log("로그확인: \(error.localizedDescription)")
            let message = "확인 \(error.localizedDescription)"
            os_log(.error, log: .default, "%@", message)
        }
        os_log("찹모찌", type: .default)
//        do {
//            try string.write(to: testURL, atomically: true, encoding: .utf8)
//        } catch {
//            print("error")
//        }
//        do {
//            try FileManager.default.moveItem(at: url!, to: testURL)
//            url = testURL
//        } catch {
//            print("error")
//        }
//
        if(url?.scheme == "file" && url?.pathExtension == "nost")
        {
//            let delay = DispatchTimeInterval.seconds(10)
//            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                //navigationController.viewControllers.first == HomeScreenViewController
                guard let homeScreenViewController = navigationController.viewControllers.first as? HomeScreenViewController else {
//                    do {
//                        try string.write(to: testURL, atomically: true, encoding: .utf8)
//                    } catch {
//                        print("error")
//                    }
                    return
                }
                //HomeScreenViewController의 pushShareView 동작(파일 URL을 같이 넣어줌)
                homeScreenViewController.pushShareView(path: url!)
//            }
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

