import UIKit
import os.log
//import KakaoSDKCommon
//import KakaoSDKAuth
@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        print("1")
        nostFileRemove()
        deleteTmpPicture()
        // moveItem한 곳을 비우는 지점(강제종료가 돼서 데이터가 남아있다 가정) 1
//        KakaoSDK.initSDK(appKey: "ba34b359e20b51a415f50d09ccd869f2")
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
        // Inbox가 생성이 되는 지점 2
        print("chopchopchop")
        print(url.absoluteString)
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //Main.storyboard의 HomeScreenViewController객체를 가져옴
        let vc = storyboard.instantiateViewController(withIdentifier: "HomeScreenViewController")
        //UINavigationController의 rootViewController를 HomeScreenViewController로 지정
        let navigationController = UINavigationController(rootViewController: vc)
        //rootViewControlelr에 객체 값 할당
        window?.rootViewController = vc
        window?.rootViewController = navigationController
        // moveItem을 하는 지점 3
        if(url.scheme == "file" && url.pathExtension == "nost")
        {
            guard let homeScreenViewController = navigationController.viewControllers.first as? HomeScreenViewController else {
                return false
            }
            //HomeScreenViewController의 pushShareView 동작(파일 URL을 같이 넣어줌)
            homeScreenViewController.pushShareView(path: url)
        }
        return true
        }
    

}

