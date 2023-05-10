import UIKit
import Zip

extension AlbumScreenViewController {
    // search button을 누를 시 동작
    @objc func searchButton(){
        guard let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "ContentsSearchViewController") as? ContentsSearchViewController else { return }
        searchVC.coverIndex = coverIndex
        searchVC.currentPageNum = pageNum
        searchVC.delegate = self
        self.present(searchVC, animated: false)
//        self.navigationController?.pushViewController(searchVC, animated: true)
    }
        
    // share button을 누를 시 동작
    @objc func shareButton() {
        let coverData = realm.objects(albumCover.self).filter("id = \(coverIndex)")
        //공유할 Object
        var shareObject = [Any]()
        var fileURL: URL? = nil
        //현재 앨범을 압축
        do {
            fileURL = try zipAlbumDirectory(AlbumCoverName: coverData.first!.albumName)
        } catch let error {
            NSErrorHandling_Alert(error: error, vc: self)
            return
        }
        
        if let file = fileURL {
            //공유 Object에 추가
            shareObject.append(file)
            //Open share sheet with shareobject
            let ac = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
            //share sheet가 닫히면 .nost파일 삭제
            ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
                do {
                    try FileManager.default.removeItem(at: file)
                } catch {
                    print("Error removing file")
                }
            }
            //open share sheet
            self.present(ac, animated: true, completion: nil)
        } else {
            
        }
    }
    
    // setting button을 누를 시 동작
    @objc func settingButton() {
        let settingVC = SettingViewController()
        settingVC.index = coverIndex
        settingVC.albumScreenVC = self
        
        self.navigationController?.pushViewController(settingVC, animated: false)
    }
    
    // info button을 누를 시 동작
    @objc func infoButton(){
        let infoVC = InfoViewController()
        infoVC.index = coverIndex
        infoVC.modalTransitionStyle = .crossDissolve
        infoVC.modalPresentationStyle = .overCurrentContext
        self.present(infoVC, animated: true, completion: nil)
    }
}

/*
 searchButton을 눌렀을 때 실행되는 function(using DisDelegate)
 */
extension AlbumScreenViewController: SearchDelegate{
    func pushPage(currentPageNum: Int, targetPageNum: Int) {
        for i in currentPageNum ... targetPageNum {
            guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else { return }
            pushVC.pageNum = i
            pushVC.coverIndex = self.coverIndex
            pushVC.albumScreenVC = self
            self.navigationController?.pushViewController(pushVC, animated: false)
        }
    }
    
    func popPage(difBetCurTar: Int) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count-difBetCurTar], animated: true)
    }
}
