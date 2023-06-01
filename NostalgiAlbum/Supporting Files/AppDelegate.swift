import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        deleteTmpFiles()
//        nostFileRemove()
//        externalFileRemove()
        deleteRestDirectoryInDocument()
        let path = NSHomeDirectory()+"/Library/SplashBoard"
        do {
            try FileManager.default.removeItem(atPath: path)
        } catch {
            print("launch screen, app icon캐시 삭제 실패: \(error)")
        }
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
        let realm = try! Realm()
        // moveItem을 하는 지점 3
        if(url.scheme == "file" && url.pathExtension == "nost")
        {
            guard let homeScreenViewController = navigationController.viewControllers.first as? HomeScreenViewController else {
                return false
            }
            if realm.objects(albumsInfo.self).count == 6 {
                let titleText = "앨범 슬롯이 꽉 찼습니다."
                let messageText = "앨범을 비워주세요."
                let errorAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
                errorAlert.setFont(font: nil, title: titleText, message: messageText)
                let okAction = UIAlertAction(title: "확인", style: .default) { action in errorAlert.dismiss(animated: false)
                }
                errorAlert.addAction(okAction)
                homeScreenViewController.present(errorAlert, animated: true)
                return false
            }

            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {
                let error = NSError(domain: NSCocoaErrorDomain, code: NSFileReadNoSuchFileError, userInfo: nil)
                NSErrorHandling_Alert(error: error, vc: homeScreenViewController)
                return false
            }
            var checkFileProvider = false
            let checkPath = url.path.split(separator: "/")
            if checkPath.contains("File Provider Storage") {
                checkFileProvider = true
                print("urlchopmojji")
            }
            
            if !checkFileProvider {
                let extURL = documentDirectory.appendingPathComponent("extTemp")
                let extfileURL = extURL.appendingPathComponent(url.lastPathComponent)
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
                homeScreenViewController.pushShareView(path: extfileURL, checkFileProvider: checkFileProvider)
            }
            homeScreenViewController.pushShareView(path: url, checkFileProvider: checkFileProvider)
        }
            return true
        }
    
    func application(_ application: UIApplication, supportedInterfaceOrientationsFor window: UIWindow?) -> UIInterfaceOrientationMask {
        // 세로방향 고정
        return UIInterfaceOrientationMask.portrait
    }

}

