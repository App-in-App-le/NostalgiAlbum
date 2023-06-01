import UIKit
import RealmSwift
import Reachability

class HomeiCloudSettingViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var backgroundStackView: UIStackView!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if let iCloudDocsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
            // 인터넷 에러 체크
            if isInternetReachable() == false {
                NSErrorHandling_Alert(error: NSError(domain: "NSURLErrorDomain", code: NSURLErrorNotConnectedToInternet), vc: self)
                return
            }
            // 필요 변수 선언
            let realm = try! Realm()
            var localNostURL = [URL]()
            var iCloudNostURL = [URL]()
            let albumCoverInfos = realm.objects(albumCover.self)
            let loadingVC = LoadingViewController()
            loadingVC.modalPresentationStyle = .overCurrentContext
            loadingVC.modalTransitionStyle = .crossDissolve
            self.present(loadingVC, animated: false, completion: nil)
            DispatchQueue.main.async {
                // 앨범이 없는 경우
                if albumCoverInfos.isEmpty == true {
                    let alert = UIAlertController(title: "앨범이 없습니다", message: "최소 한 개 이상의 앨범을 생성 후 백업을 진행해주세요", preferredStyle: .alert)
                    alert.setFont(font: nil, title: "앨범이 없습니다", message: "최소 한 개 이상의 앨범을 생성 후 백업을 진행해주세요")
                    let okAction = UIAlertAction(title: "확인", style: .default) { action in
                        self.dismiss(animated: false) {
                            self.dismiss(animated: false)
                        }
                    }
                    alert.addAction(okAction)
                    loadingVC.dismiss(animated: false) {
                        self.present(alert, animated: true)
                    }
                    return
                }
                // 앨범이 존재하는 경우
                else {
                    // iCloudDocsURL에 Document 폴더가 존재하지 않는 경우 생성
                    if !FileManager.default.fileExists(atPath: iCloudDocsURL.path, isDirectory: nil) {
                        try? FileManager.default.createDirectory(at: iCloudDocsURL, withIntermediateDirectories: true, attributes: nil)
                        print("DATA BACK UP :: CREATE iCLOUD DIRECTORY")
                    }
                    // 백업 동작 시작
                    do {
                        var contents = try FileManager.default.contentsOfDirectory(atPath: iCloudDocsURL.path)
                        var message = String()
                        // iCloud Drive에 .Trash 파일과 .iCloud 파일에 대한 처리
                        if !contents.isEmpty {
                            var Datas = [String]()
                            for content in contents {
                                if content.hasSuffix(".Trash") {
                                    do {
                                        try FileManager.default.removeItem(at: iCloudDocsURL.appendingPathComponent(content))
                                    } catch let error as NSError {
                                        print("FileManager Remove Error Occur :: \(error)")
                                    }
                                } else if content.hasSuffix(".icloud") {
                                    do {
                                        var modifiedContent = content
                                        modifiedContent.removeFirst()
                                        let iCloudFileURL = iCloudDocsURL.appendingPathComponent(content)
                                        let destinationURL = iCloudDocsURL.appendingPathComponent(modifiedContent).deletingPathExtension()
                                        // 파일 다운로드 시작
                                        try FileManager.default.startDownloadingUbiquitousItem(at: iCloudFileURL)
                                        // 파일 다운로드가 완료될 때까지 대기
                                        while !FileManager.default.fileExists(atPath: destinationURL.path) {
                                            continue
                                        }
                                    } catch let error {
                                        // 백업 파일이 남으면 앱 시작 시, 알아서 삭제되도록 핸들링 함
                                        print("FileManager DownLoadiCloudFiles Error Occur :: \(error.localizedDescription)")
                                        loadingVC.dismiss(animated: false) {
                                            NSErrorHandling_Alert(error: error, vc: self)
                                            return
                                        }
                                    }
                                }
                            }
                            // 첫 번째 엘럿 메세지
                            contents = try FileManager.default.contentsOfDirectory(atPath: iCloudDocsURL.path)
                            for content in contents {
                                Datas.append("앨범 명: \(content.replacingOccurrences(of: ".nost", with: "").precomposedStringWithCanonicalMapping)")
                            }
                            message = "1. 백업 진행 시, 이전 백업 데이터가 삭제되고 현재 앨범 정보가 저장됩니다.\n\n2. 백업 중 네트워크 연결 끊김과 앱 종료에 주의해주세요.\n\n기존 백업 데이터가 존재합니다!\n\n[이전 백업 데이터]\n\(Datas.joined(separator: "\n"))"
                        } else {
                            message = "1. 백업 진행 시, 이전 백업 데이터가 삭제되고 현재 앨범 정보가 저장됩니다.\n\n2. 백업 중 네트워크 연결 끊김과 앱 종료에 주의해주세요.\n\n이전 백업 데이터가 존재하지 않습니다."
                        }
                        // 다운로드 완료 후 loadingVC를 dismiss
                        loadingVC.dismiss(animated: false) {
                            let alert = UIAlertController(title: "백업", message: message, preferredStyle: .alert)
                            alert.setFont(font: nil, title: "백업", message: message)
                            
                            let okAction = UIAlertAction(title: "확인", style: .default) { action in
                                for albumCoverInfo in albumCoverInfos {
                                    do {
                                        if let newNostURL = try zipAlbumDirectory(AlbumCoverName: albumCoverInfo.albumName) {
                                            localNostURL.append(newNostURL)
                                            iCloudNostURL.append(iCloudDocsURL.appendingPathComponent("\(albumCoverInfo.albumName).nost"))
                                        } else {
                                            // newNostURL이 nil인 경우 -> 맨 앞줄 오류라 txt파일 생성 안됨 -> 삭제 할 필요 없음
                                            // 에러를 불러올 수 없으니 직접 입력
                                            let error = NSError(domain: "NSCocoaErrorDomain", code: NSFileWriteNoPermissionError)
                                            NSErrorHandling_Alert(error: error, vc: self)
                                            return
                                        }
                                    } catch let error {
                                        // zipDocumentDirectory 함수 실행 중 생성된 잔여 txt 파일들 삭제
                                        do {
                                            let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
                                            let contents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.appendingPathComponent(albumCoverInfo.albumName).path)
                                            for content in contents {
                                                if content.hasSuffix(".txt") {
                                                    do {
                                                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent(albumCoverInfo.albumName).appendingPathComponent(content))
                                                    }
                                                }
                                            }
                                        } catch let error as NSError{
                                            print("FileManager Error Occur :: \(error)")
                                        }
                                        NSErrorHandling_Alert(error: error, vc: self)
                                        return
                                    }
                                }
                                // 기존에 백업된 파일 삭제
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
                                // 새로운 백업 파일 iCloud Drive로 전송 및 iCloud에 업로드
                                for index in 0...localNostURL.count - 1 {
                                    do {
                                        // flag: true -> iCloud에 업로드 (수동 업로드) -> 에러를 잡기 위해 설정
                                        try FileManager.default.setUbiquitous(true, itemAt: localNostURL[index], destinationURL: iCloudNostURL[index])
                                    } catch let error {
                                        // iCloud에 업로드하다가 실패한 경우
                                        print("DATA BACK UP :: UPLOAD FAIL TO iCLOUD DRIVER \(error) ")
                                        // iCloud Drive와 local Document에 남은 백업 파일 모두 삭제
                                        for url in localNostURL {
                                            if FileManager.default.fileExists(atPath: url.path) {
                                                do {
                                                    try FileManager.default.removeItem(at: url)
                                                } catch let error as NSError {
                                                    print("FileManager Remove Error Occur :: \(error)")
                                                }
                                            }
                                        }
                                        for url in iCloudNostURL {
                                            if FileManager.default.fileExists(atPath: url.path) {
                                                do {
                                                    try FileManager.default.removeItem(at: url)
                                                } catch let error as NSError {
                                                    print("FileManager Remove Error Occur :: \(error)")
                                                }

                                            }
                                        }
                                        NSErrorHandling_Alert(error: error, vc: self)
                                        return
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
                            self.present(alert, animated: false)
                        }
                    } catch {
                        print("ERROR :: FileManager contentsOfDirectory")
                    }
                }
            }
        } else {
            // iCloud 자동 연결 설정이 안된 경우 Alert 띄우기
            let alert = UIAlertController(title: "iCloud 연결이 필요합니다", message: "\n설정 - Apple ID - iCloud - 모두 보기 - NostelgiAlbum - 허용 ", preferredStyle: .alert)
            alert.setFont(font: nil, title: "iCloud 연결이 필요합니다", message: "\n설정 - Apple ID - iCloud - 모두 보기 - NostelgiAlbum - 허용 ")
            let okAction = UIAlertAction(title: "확인", style: .default) { action in
                alert.dismiss(animated: false)
            }
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    @IBAction func recoverButtonAction(_ sender: Any) {
        // 인터넷 에러 체크
        if isInternetReachable() == false {
            NSErrorHandling_Alert(error: NSError(domain: "NSURLErrorDomain", code: NSURLErrorNotConnectedToInternet), vc: self)
            return
        }
        
        // 필요 변수 선언
        var AlbumDatas = [String]()
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        
        // loadingVC를 Present하고 기존 iCloud 파일을 다운로드
        self.present(loadingVC, animated: false, completion: nil)
        DispatchQueue.main.async {
            // iCloud 연결에 성공한 경우
            if let iCloudDocsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
                do {
                    var contents = try FileManager.default.contentsOfDirectory(atPath: iCloudDocsURL.path)
                    for content in contents {
                        if content.hasSuffix(".Trash") {
                            do {
                                try FileManager.default.removeItem(at: iCloudDocsURL.appendingPathComponent(content))
                            } catch let error as NSError {
                                print("FileManager Remove Error Occur :: \(error)")
                            }
                        } else if content.hasSuffix(".icloud") {
                            do {
                                var modifiedContent = content
                                modifiedContent.removeFirst()
                                let iCloudFileURL = iCloudDocsURL.appendingPathComponent(content)
                                let destinationURL = iCloudDocsURL.appendingPathComponent(modifiedContent).deletingPathExtension()
                                // 파일 다운로드 시작
                                try FileManager.default.startDownloadingUbiquitousItem(at: iCloudFileURL)
                                // 파일 다운로드 완료까지 기다리기
                                while !FileManager.default.fileExists(atPath: destinationURL.path) {
                                    continue
                                }
                            } catch let error {
                                print("FileManager DownLoadiCloudFiles Error Occur :: \(error.localizedDescription)")
                                loadingVC.dismiss(animated: false) {
                                    NSErrorHandling_Alert(error: error, vc: self)
                                    return
                                }
                            }
                        }
                    }
                    contents = try FileManager.default.contentsOfDirectory(atPath: iCloudDocsURL.path)
                    // 복원받을 파일이 존재하지 않는 경우 처리
                    if contents.isEmpty {
                        let alert = UIAlertController(title: "백업 파일이 존재하지 않습니다", message: nil, preferredStyle: .alert)
                        alert.setFont(font: nil, title: "백업 파일이 존재하지 않습니다", message: nil)
                        
                        let okAction = UIAlertAction(title: "확인", style: .default) { action in
                            alert.dismiss(animated: false)
                        }
                        alert.addAction(okAction)
                        loadingVC.dismiss(animated: false) {
                            self.present(alert, animated: false)
                            return
                        }
                    } else {
                        AlbumDatas = contents
                    }
                } catch {
                    print("ERROR :: FileManager contentsOfDirectory")
                }
            } else {
                // iCloud 연결에 실패한 경우
                let alert = UIAlertController(title: "iCloud 연결이 필요합니다", message: "\n설정 - Apple ID - iCloud - 모두 보기 - NostelgiAlbum - 허용 ", preferredStyle: .alert)
                alert.setFont(font: nil, title: "iCloud 연결이 필요합니다", message: "\n설정 - Apple ID - iCloud - 모두 보기 - NostelgiAlbum - 허용 ")
                
                let okAction = UIAlertAction(title: "확인", style: .default) { action in
                    alert.dismiss(animated: false)
                }
                alert.addAction(okAction)
                loadingVC.dismiss(animated: false) {
                    self.present(alert, animated: true)
                    return
                }
            }
            // iCloud에서 다운로드가 완료된 경우
            loadingVC.dismiss(animated: false) {
                let alert = UIAlertController(title: "경고", message: "복원을 진행할 경우 \n현재 생성된 앨범 정보가 모두 삭제됩니다", preferredStyle: .alert)
                alert.setFont(font: nil, title: "경고", message: "복원을 진행할 경우 \n현재 생성된 앨범 정보가 모두 삭제됩니다")
                
                let cancleAction = UIAlertAction(title: "취소", style: .default) { action in
                    alert.dismiss(animated: false)
                }
                let okAction = UIAlertAction(title: "확인", style: .default) { action in
                    var Datas = [String]()
                    for AlbumData in AlbumDatas {
                        Datas.append("앨범 명: \(AlbumData.replacingOccurrences(of: ".nost", with: "").precomposedStringWithCanonicalMapping)")
                    }
                    let message = "[백업 데이터]\n\(Datas.joined(separator: "\n"))"
                    
                    let alert = UIAlertController(title: "복원", message: "1. 복원 완료 시 기존의 백업 데이터는 소멸됩니다.\n\n2. 복원 중 네트워크 연결 끊김과 앱 종료에 주의해주세요.\n\n3. 복원이 완료되면 앱이 종료됩니다.\n\n현재 존재하는 앨범 정보를 삭제하고 복원을 진행하시겠습니까?\n\n\(message)", preferredStyle: .alert)
                    alert.setFont(font: nil, title: "복원", message: "1. 복원 완료 시 기존의 백업 데이터는 소멸됩니다.\n\n2. 복원 중 네트워크 연결 끊김과 앱 종료에 주의해주세요.\n\n3. 복원이 완료되면 앱이 종료됩니다.\n\n현재 존재하는 앨범 정보를 삭제하고 복원을 진행하시겠습니까?\n\n\(message)")
                    
                    let cancleAction = UIAlertAction(title: "취소", style: .default) { action in
                        alert.dismiss(animated: false)
                    }
                    let confirmAction = UIAlertAction(title: "확인", style: .default) { action in
                        if let iCloudDocsURL = FileManager.default.url(forUbiquityContainerIdentifier: nil)?.appendingPathComponent("Documents") {
                            guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                            // 기존 정보 복사 -> 복원 실패 대비
                            do {
                                try FileManager.default.createDirectory(atPath: documentDirectory.appendingPathComponent("recovery_backup").path, withIntermediateDirectories: true, attributes: nil)
                                let contents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.path)
                                for content in contents {
                                    if content == "recovery_backup" {
                                        continue
                                    }
                                    do {
                                        try FileManager.default.copyItem(at: documentDirectory.appendingPathComponent(content), to: documentDirectory.appendingPathComponent("recovery_backup").appendingPathComponent(content))
                                    }
                                }
                            } catch let error as NSError {
                                // 용량 부족 및 다양한 문제가 발생 할 수 있기 때문
                                NSErrorHandling_Alert(error: error, vc: self)
                                // 에러 발생 시 만들던 복사본 디렉토리 삭제
                                do {
                                    try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("recovery_backup"))
                                } catch let error as NSError {
                                    print("FileManager remove Directory Error :: \(error)")
                                }
                                return
                            }
                            // 기존 정보 삭제
                            // Document 정보 삭제
                            do {
                                let contents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.path)
                                for content in contents {
                                    if !content.hasPrefix("default") && !content.hasSuffix("Inbox") && content != "recovery_backup" {
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
                            
                            // 복원 파일 압축 해제 + RealmDB에 입력
                            do {
                                let contents = try FileManager.default.contentsOfDirectory(atPath: iCloudDocsURL.path)
                                for content in contents {
                                    if content.hasSuffix(".nost") {
                                        let albumCoverName = content.replacingOccurrences(of: ".nost", with: "").precomposedStringWithCanonicalMapping
                                        let shareFilePath = iCloudDocsURL.appendingPathComponent(content)
                                        do{
                                            // deleteShareFile: false -> 백업 파일은 성공 시 삭제
                                            try unzipAlbumDirectory(AlbumCoverName: albumCoverName, shareFilePath: shareFilePath, checkFileProvider: true)
                                        } catch let error {
                                            // 디비 정보, 사진 정보, 백업 파일 전부 백업했다가 실패 시 전체 복원
                                            do {
                                                // Document 파일 전체 삭제
                                                var contents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.path)
                                                for content in contents {
                                                    do {
                                                        if content == "recovery_backup" {
                                                            continue
                                                        }
                                                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent(content))
                                                    } catch let error as NSError {
                                                        print("FileManager removeItem Error :: \(error)")
                                                    }
                                                }
                                                // Document에 이전 파일 복원
                                                contents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.appendingPathComponent("recovery_backup").path)
                                                for content in contents {
                                                    do {
                                                        try FileManager.default.moveItem(at: documentDirectory.appendingPathComponent("recovery_backup").appendingPathComponent(content), to: documentDirectory.appendingPathComponent(content))
                                                    } catch let error as NSError {
                                                        print("FileManager moveItem Error :: \(error)")
                                                    }
                                                }
                                                // recovery_backup 폴더 삭제
                                                do {
                                                    try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("recovery_backup"))
                                                } catch let error as NSError {
                                                    print("FileManager removeItem Error :: \(error)")
                                                }
                                            } catch let error as NSError {
                                                print("FileManager contentsOfDirectory Error :: \(error)")
                                            }
                                            // Alert 띄우기
                                            NSErrorHandling_Alert(error: error, vc: self)
                                            return
                                        }
                                        
                                        do{
                                            try importAlbumInfo(albumCoverName: albumCoverName, useForShare: false)
                                        } catch let error {
                                            // 디비 정보, 사진 정보, 백업 파일 전부 백업했다가 실패 시 전체 복원
                                            do {
                                                // Document 파일 전체 삭제
                                                var contents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.path)
                                                for content in contents {
                                                    do {
                                                        if content == "recovery_backup" {
                                                            continue
                                                        }
                                                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent(content))
                                                    } catch let error as NSError {
                                                        print("FileManager removeItem Error :: \(error)")
                                                    }
                                                }
                                                // Document에 이전 파일 복원
                                                contents = try FileManager.default.contentsOfDirectory(atPath: documentDirectory.appendingPathComponent("recovery_backup").path)
                                                for content in contents {
                                                    do {
                                                        try FileManager.default.moveItem(at: documentDirectory.appendingPathComponent("recovery_backup").appendingPathComponent(content), to: documentDirectory.appendingPathComponent(content))
                                                    } catch let error as NSError {
                                                        print("FileManager moveItem Error :: \(error)")
                                                    }
                                                }
                                                // recovery_backup 폴더 삭제
                                                do {
                                                    try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("recovery_backup"))
                                                } catch let error as NSError {
                                                    print("FileManager removeItem Error :: \(error)")
                                                }
                                            } catch let error as NSError {
                                                print("FileManager contentsOfDirectory Error :: \(error)")
                                            }
                                            // Alert 띄우기
                                            NSErrorHandling_Alert(error: error, vc: self)
                                            return
                                        }
                                    }
                                }
                                // 성공
                                print("SUCCESS :: Complete Recover!")
                                
                                // iCloud에 있는 백업 파일 삭제
                                for content in contents {
                                    let shareFilePath = iCloudDocsURL.appendingPathComponent(content)
                                    do {
                                        try FileManager.default.removeItem(at: shareFilePath)
                                    } catch let error as NSError {
                                        print("FileManager removeItem Error :: \(error)")
                                    }
                                }
                                
                                // recovery_backup directory 삭제
                                do {
                                    try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("recovery_backup"))
                                } catch let error as NSError {
                                    print("FileManager removeItem error Occur :: \(error)")
                                }
                                
                                // 앱 종료
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
                self.present(alert, animated: true)
            }
        }
    }
}
