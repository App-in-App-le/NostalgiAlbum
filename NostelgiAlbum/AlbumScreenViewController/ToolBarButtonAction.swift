import UIKit

extension AlbumScreenViewController {
    //search button을 누를 시 동작
    @objc func searchButton(){
        guard let searchVC = self.storyboard?.instantiateViewController(withIdentifier: "ContentsSearchViewController") as? ContentsSearchViewController else { return }
        searchVC.modalPresentationStyle = .overFullScreen
        searchVC.coverIndex = coverIndex
        searchVC.currentPageNum = pageNum
        searchVC.delegate = self
        self.present(searchVC, animated: false)
    }
        
    //share button을 누를 시 동작
    @objc func shareButton() {
        let coverData = realm.objects(albumCover.self).filter("id = \(coverIndex)")
        //공유할 Object
        var shareObject = [Any]()
        //현재 앨범을 압축
        let fileURL = zipAlbumDirectory(AlbumCoverName: coverData.first!.albumName)
        //권한 부여(필요 유무 확인 필)
        do {
            let attributes = try FileManager.default.attributesOfItem(atPath: fileURL!.path)
            let permissions =
            attributes[.posixPermissions] as! Int
            let newPermissions = permissions | Int(0o777)
            try FileManager.default.setAttributes([.posixPermissions: newPermissions], ofItemAtPath: fileURL!.path)
        } catch {
            print("Error setting file permissions: \(error)")
        }
        //공유 Object에 추가
        shareObject.append(fileURL!)
        //Open share sheet with shareobject
        let ac = UIActivityViewController(activityItems: shareObject, applicationActivities: nil)
        //share sheet가 닫히면 .nost파일 삭제
        ac.completionWithItemsHandler = {(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            if completed {
                do {
                    try FileManager.default.removeItem(at: fileURL!)
                } catch {
                    print("Error removing file")
                }
            } else {
                do {
                    try FileManager.default.removeItem(at: fileURL!)
                } catch {
                    print("Error removing file")
                }
            }
        }
        //open share sheet
        self.present(ac, animated: true, completion: nil)
    }
    
    //info button을 누를 시 동작
    @objc func infoButton(){
        let infoVC = InfoTableViewController()
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
            self.navigationController?.pushViewController(pushVC, animated: true)
        }
    }
    
    func popPage(difBetCurTar: Int) {
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController(viewControllers[viewControllers.count-difBetCurTar], animated: true)
    }
    
    //text는 검색 시 입력한 내용
    func delegateString(text: String) {
        let data = realm.objects(album.self).filter("index = \(coverIndex)")
        var num : Int = 0
        var checkcount : Int = pageNum
        //Album내 페이지 viewControllers목록(NavigationController를 통해 관리)
        let viewControllers: [UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        //검색한 내용이 있을 경우
        if let result = data.firstIndex(where: {$0.ImageName == text}){
            if(result/2 > checkcount){
                //한 개씩 push
                while checkcount < result/2 {
                    guard let pushVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumScreenViewController") as? AlbumScreenViewController else{ return }
                    checkcount = checkcount + 1
                    pushVC.pageNum = checkcount
                    pushVC.coverIndex = self.coverIndex
                    self.navigationController?.pushViewController(pushVC, animated: false)
                }
            } else { //pop해서 이동할 viewcontrollers까지의 count 찾기
                while checkcount >= result/2 {
                    checkcount = checkcount - 1
                    num = num + 1
                }
                //해당 count만큼 pop
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - num], animated: false)
            }
        } else {
            print("none")
        }
    }
}
