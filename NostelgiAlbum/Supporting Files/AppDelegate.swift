import UIKit
import os.log

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        deleteTmpFiles()
        nostFileRemove()
        externalFileRemove()
        sleep(1)
        return true
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any]) -> Bool {
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
            
            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                let error = NSError(domain: NSCocoaErrorDomain, code: NSFileReadNoSuchFileError, userInfo: nil)
                NSErrorHandling_Alert(error: error, vc: homeScreenViewController)
                return false
            }
            let extURL = documentDirectory.appendingPathComponent("extTemp")
            let extfileURL = extURL.appendingPathComponent(url.lastPathComponent)
            print("urllast:\(url.lastPathComponent)")
            print("extfileURL:\(extfileURL)")
            do {
                if !FileManager.default.fileExists(atPath: extURL.path) {
                    try FileManager.default.createDirectory(at: extURL, withIntermediateDirectories: true, attributes: nil)
                }
                do {
                    try FileManager.default.moveItem(at: url, to: extfileURL)
                } catch let error {
                    print("move error")
                    print("error:\(error.localizedDescription)")
                    NSErrorHandling_Alert(error: error, vc: homeScreenViewController)
                }
            } catch let error {
                print("create dir error")
                NSErrorHandling_Alert(error: error, vc: homeScreenViewController)
            }
            //HomeScreenViewController의 pushShareView 동작(파일 URL을 같이 넣어줌)
            homeScreenViewController.pushShareView(path: extfileURL)
        }
            return true
        }
    

}

