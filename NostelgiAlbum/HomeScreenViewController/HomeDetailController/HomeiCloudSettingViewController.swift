import UIKit
import RealmSwift

class HomeiCloudSettingViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var backgroundStackView: UIStackView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        backgroundStackView.layer.cornerRadius = 5
        backgroundStackView.layer.borderWidth = 2
        backgroundStackView.layer.borderColor = UIColor.black.cgColor
        backgroundStackView.backgroundColor = .systemGray5
    }
    
    // MARK: - Methods
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss(animated: false)
    }
    
    @IBAction func homeSettingButtonAction(_ sender: Any) {
        dismiss(animated: false)
    }
    
    @IBAction func backupButtonAction(_ sender: Any) {
        // Set iCloudDocsURL Here & Do Nil Check
        if let iCloudDocsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            // Make albums' Nost file
            let realm = try! Realm()
            var localNostURL = [URL]()
            var iCloudNostURL = [URL]()
            let albumCoverInfos = realm.objects(albumCover.self)
            if albumCoverInfos.isEmpty == true {
                // Alert
                // Notice Alert
                let alert = UIAlertController(title: "앨범이 없습니다", message: "최소 한 개 이상의 앨범을 생성 후 백업을 진행해주세요", preferredStyle: .alert)
                alert.setFont(font: nil, title: "앨범이 없습니다", message: "최소 한 개 이상의 앨범을 생성 후 백업을 진행해주세요")
                let okAction = UIAlertAction(title: "확인", style: .default) { action in
                    self.dismiss(animated: false) {
                        self.dismiss(animated: false)
                    }
                }
                alert.addAction(okAction)
                present(alert, animated: true)
                return
            } else {
                // Check File Path Exist Or Not
                if !FileManager.default.fileExists(atPath: iCloudDocsURL.path, isDirectory: nil) {
                    // Case File Path Doesn't Exist, Make Directory Here
                    try? FileManager.default.createDirectory(at: iCloudDocsURL, withIntermediateDirectories: true, attributes: nil)
                    print("DATA BACK UP :: CREATE iCLOUD DIRECTORY")
                }
                // BackUp
                do {
                    let contents = try FileManager.default.contentsOfDirectory(atPath: iCloudDocsURL.path)
                    var message = String()
                    if !contents.isEmpty {
                        var Datas = [String]()
                        for content in contents {
                            Datas.append("앨범 명: \(content.replacingOccurrences(of: ".nost", with: ""))")
                        }
                        message = "1. 백업 진행 시, 이전 백업 데이터가 삭제되고 현재 앨범 정보가 저장됩니다.\n\n2. 백업 중 네트워크 연결 끊김과 앱 종료에 주의해주세요.\n\n기존 백업 데이터가 존재합니다!\n\n[이전 백업 데이터]\n\(Datas.joined(separator: "\n"))"
                    } else {
                        message = "1. 백업 진행 시, 이전 백업 데이터가 삭제되고 현재 앨범 정보가 저장됩니다.\n\n2. 백업 중 네트워크 연결 끊김과 앱 종료에 주의해주세요.\n\n이전 백업 데이터가 존재하지 않습니다."
                    }
                    
                    let alert = UIAlertController(title: "백업", message: message, preferredStyle: .alert)
                    alert.setFont(font: nil, title: "백업", message: message)
                    
                    let okAction = UIAlertAction(title: "확인", style: .default) { action in
                        for albumCoverInfo in albumCoverInfos {
                            do {
                                if let newNostURL = try zipAlbumDirectory(AlbumCoverName: albumCoverInfo.albumName) {
                                    localNostURL.append(newNostURL)
                                    iCloudNostURL.append(iCloudDocsURL.appendingPathComponent("\(albumCoverInfo.albumName).nost"))
                                } else {
                                    // newNostURL이 nil인 경우
                                }
                            } catch let error {
                                // 백업 중에 zipAlbumDirectory에서 문제가 발생
                                // 백업 중이던 파일을 전부 삭제해줘야 함 -> 문제 발생 시, 앱 껏다 키면 .nost파일은 nostFiles에 있어서 다 알아서 삭제 됨.
                                NSErrorHandling_Alert(error: error, vc: self)
                                return
                            }
                        }
                        
                        // 기존에 백업된 정보 전부 삭제
                        do {
                            let contents = try FileManager.default.contentsOfDirectory(atPath: iCloudDocsURL.path)
                            for content in contents {
                                do {
                                    try FileManager.default.removeItem(at: iCloudDocsURL.appendingPathComponent(content))
                                } catch {
                                    print("ERROR :: iCloud remove error")
                                }
                            }
                        } catch {
                            print("ERROR :: FileManager Bring iCloud Document Path Error")
                        }
                        
                        for index in 0...localNostURL.count - 1 {
                            do {
                                // Copy Local Directory File Contents To iCloud Driver
                                try FileManager.default.copyItem(at: localNostURL[index], to: iCloudNostURL[index])
                                // Delete Local Nost File
                                try FileManager.default.removeItem(at: localNostURL[index])
                                print("DATA BACK UP :: UPLOAD SUCCESS TO iCLOUD DRIVER")
                            } catch let error as NSError {
                                // Handling Exception Here When You Developing
                                print("DATA BACK UP :: UPLOAD FAIL TO iCLOUD DRIVER \(error) ")
                            }
                        }
                        
                        let alert = UIAlertController(title: "백업 완료", message: "백업이 완료되었습니다.", preferredStyle: .alert)
                        alert.setFont(font: nil, title: "백업 완료", message: "백업이 완료되었습니다.")
                        
                        let okAction = UIAlertAction(title: "확인", style: .default) { action in
                            self.dismiss(animated: false)
                        }
                        alert.addAction(okAction)
                        self.present(alert, animated: true)
                    }
                    let cancleAction = UIAlertAction(title: "취소", style: .default) { action in
                        alert.dismiss(animated: false)
                    }
                    alert.addAction(okAction)
                    alert.addAction(cancleAction)
                    present(alert, animated: false)
                } catch {
                    print("ERROR :: FileManager contentsOfDirectory")
                }
            }
        } else {
            // Notice Alert
            let alert = UIAlertController(title: "iCloud 연결이 필요합니다", message: "\n설정 - Apple ID - iCloud - 모두 보기 - NostelgiAlbum - 허용 ", preferredStyle: .alert)
            alert.setFont(font: nil, title: "iCloud 연결이 필요합니다", message: "\n설정 - Apple ID - iCloud - 모두 보기 - NostelgiAlbum - 허용 ")
            let okAction = UIAlertAction(title: "확인", style: .default) { action in
                alert.dismiss(animated: false)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
        }
    }
    
    @IBAction func recoverButtonAction(_ sender: Any) {
        var AlbumDatas = [String]()
        
        if let iCloudDocsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            // Success
            // Notice Alert
            do {
                let contents = try FileManager.default.contentsOfDirectory(atPath: iCloudDocsURL.path)
                if contents.isEmpty {
                    let alert = UIAlertController(title: "백업 파일이 존재하지 않습니다", message: nil, preferredStyle: .alert)
                    alert.setFont(font: nil, title: "백업 파일이 존재하지 않습니다", message: nil)
                    
                    let okAction = UIAlertAction(title: "확인", style: .default) { action in
                        alert.dismiss(animated: false)
                    }
                    alert.addAction(okAction)
                    present(alert, animated: false)
                    return
                } else {
                    AlbumDatas = contents
                }
            } catch {
                print("ERROR :: FileManager contentsOfDirectory")
            }
        } else {
            // Failed
            // Notice Alert
            let alert = UIAlertController(title: "iCloud 연결이 필요합니다", message: "\n설정 - Apple ID - iCloud - 모두 보기 - NostelgiAlbum - 허용 ", preferredStyle: .alert)
            alert.setFont(font: nil, title: "iCloud 연결이 필요합니다", message: "\n설정 - Apple ID - iCloud - 모두 보기 - NostelgiAlbum - 허용 ")
            
            let okAction = UIAlertAction(title: "확인", style: .default) { action in
                alert.dismiss(animated: false)
            }
            alert.addAction(okAction)
            present(alert, animated: true)
            return
        }
        
        let alert = UIAlertController(title: "경고", message: "복원을 진행할 경우 \n현재 생성된 앨범 정보가 모두 삭제됩니다", preferredStyle: .alert)
        alert.setFont(font: nil, title: "경고", message: "복원을 진행할 경우 \n현재 생성된 앨범 정보가 모두 삭제됩니다")
        
        let cancleAction = UIAlertAction(title: "취소", style: .default) { action in
            alert.dismiss(animated: false)
        }
        let okAction = UIAlertAction(title: "확인", style: .default) { action in
            var Datas = [String]()
            for AlbumData in AlbumDatas {
                Datas.append("앨범 명: \(AlbumData.replacingOccurrences(of: ".nost", with: ""))")
            }
            let message = "[백업 데이터]\n\(Datas.joined(separator: "\n"))"
            
            let alert = UIAlertController(title: "복원", message: "1. 복원 완료 시 기존의 백업 데이터는 소멸됩니다.\n\n2. 복원 중 네트워크 연결 끊김과 앱 종료에 주의해주세요.\n\n3. 복원이 완료되면 앱이 종료됩니다.\n\n현재 존재하는 앨범 정보를 삭제하고 복원을 진행하시겠습니까?\n\n\(message)", preferredStyle: .alert)
            alert.setFont(font: nil, title: "복원", message: "1. 복원 완료 시 기존의 백업 데이터는 소멸됩니다.\n\n2. 복원 중 네트워크 연결 끊김과 앱 종료에 주의해주세요.\n\n3. 복원이 완료되면 앱이 종료됩니다.\n\n현재 존재하는 앨범 정보를 삭제하고 복원을 진행하시겠습니까?\n\n\(message)")
            
            let cancleAction = UIAlertAction(title: "취소", style: .default) { action in
                alert.dismiss(animated: false)
            }
            let confirmAction = UIAlertAction(title: "확인", style: .default) { action in
                if let iCloudDocsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
                    // 기존 정보 삭제
                    // Document 정보 삭제
                    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                    do {
                        let contents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.path)
                        for content in contents {
                            if !content.hasPrefix("default") && !content.hasSuffix("Inbox") {
                                print(content)
                                do {
                                    try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent(content))
                                } catch {
                                    print("ERROR :: FileManager remove error")
                                }
                            }
                        }
                    } catch {
                        print("ERROR :: FileManager Bring Document Path Error")
                    }

                    // RealmDB 정보 삭제
                    let realm = try! Realm()
                    let albumCover = realm.objects(albumCover.self)
                    let album = realm.objects(album.self)
                    let albumsInfo = realm.objects(albumsInfo.self)

                    for albumCoverData in albumCover {
                        do {
                            try realm.write {
                                realm.delete(albumCoverData)
                            }
                        } catch {
                            print("ERROR :: Cannot delete albumCover data in realmDB")
                        }
                    }
                    for albumData in album {
                        do {
                            try realm.write {
                                realm.delete(albumData)
                            }
                        } catch {
                            print("ERROR :: Cannot delete album data in realmDB")
                        }
                    }
                    for albumsInfoData in albumsInfo {
                        do {
                            try realm.write {
                                realm.delete(albumsInfoData)
                            }
                        } catch {
                            print("ERROR :: Cannot delete albumsInfo data in realmDB")
                        }
                    }

                    // unzip & import data
                    do {
                        let contents = try FileManager.default.contentsOfDirectory(atPath: iCloudDocsURL.path)
                        print(contents)
                        for content in contents {
                            if content.hasSuffix(".nost") {
                                let albumCoverName = content.replacingOccurrences(of: ".nost", with: "")
                                let shareFilePath = iCloudDocsURL.appendingPathComponent(content)
                                do{
                                    try unzipAlbumDirectory(AlbumCoverName: albumCoverName, shareFilePath: shareFilePath)
                                } catch let error {
                                    NSErrorHandling_Alert(error: error, vc: self)
                                    // MARK: - 해제 된 디렉토리들을 이름을 비교해서 전부 삭제 해줘야 함
                                    // 풀릴 예정이었던 앨범 이름들을 전부 가져오는 방법을 생각해봐야 함
                                    
                                    return
                                }
                                do{
                                    try importAlbumInfo(albumCoverName: albumCoverName, useForShare: false)
                                } catch let error {
                                    NSErrorHandling_Alert(error: error, vc: self)
                                    // MARK: - 이미 import 되어버린 부분들을 되돌릴 방법을 찾아봐야함 (RealmDB는 너무 까다로움)
                                    // 난이도 급상승 구간
                                    return
                                }
                            }
                        }
                        print("SUCCESS :: Complete Recover!")
                        UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            exit(0)
                        }
                    } catch let error as NSError {
                        // Handling Exception Here When You Developing
                        print("TEST Error :: UPLOAD FAIL TO iCLOUD DRIVER \(error)")
                    }
                }
            }
            alert.addAction(confirmAction)
            alert.addAction(cancleAction)
            self.present(alert, animated: true)
        }
        alert.addAction(okAction)
        alert.addAction(cancleAction)
        present(alert, animated: true)
    }
}
