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
        var titleText = ""
        var messageText = ""
        let errorAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        errorAlert.setFont(font: nil, title: titleText, message: messageText)
        let okAction = UIAlertAction(title: "확인", style: .default) { action in
            errorAlert.dismiss(animated: false)
        }
        errorAlert.addAction(okAction)
        let coverData = realm.objects(albumCover.self).filter("id = \(coverIndex)")
        //공유할 Object
        var shareObject = [Any]()
        var fileURL: URL? = nil
        //현재 앨범을 압축
        do {
            fileURL = try zipAlbumDirectory(AlbumCoverName: coverData.first!.albumName)
        } catch let error {
            switch error {
            case ZipError.zipFail:
                titleText = "압축 실패"
                messageText = "압축에 실패했습니다."
                present(errorAlert, animated: true)
                break
            case let nsError as NSError where nsError.code == NSFileWriteFileExistsError:
                titleText = "기존 파일 존재"
                messageText = "기존의 파일이 존재하고 있습니다."
                present(errorAlert, animated: true)
                break
            case let nsError as NSError where nsError.code == NSFileWriteInapplicableStringEncodingError:
                titleText = "인코딩 문제"
                messageText = "인코딩이 맞지 않아 파일 작성이 불가합니다."
                present(errorAlert, animated: true)
                break
            case let nsError as NSError where nsError.code == NSFileWriteInvalidFileNameError:
                titleText = "잘못된 이름"
                messageText = "파일 이름이 잘못되었습니다."
                present(errorAlert, animated: true)
                break
            case let nsError as NSError where nsError.code == NSFileWriteNoPermissionError:
                titleText = "권한 부재"
                messageText = "파일을 작성할 권한이 없습니다."
                present(errorAlert, animated: true)
                break
            case let nsError as NSError where nsError.code == NSFileWriteOutOfSpaceError:
                titleText = "용량 부족"
                messageText = "디바이스에 용량이 부족합니다."
                present(errorAlert, animated: true)
                break
            case let nsError as NSError where nsError.code == NSFileWriteVolumeReadOnlyError:
                titleText = "읽기 전용"
                messageText = "현재 읽기만 가능한 상태입니다."
                present(errorAlert, animated: true)
                break
            default:
                titleText = "파일 생성 실패"
                messageText = "파일 생성에 실패했습니다. 다시 시도해주세요."
                present(errorAlert, animated: true)
                break
            }
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
