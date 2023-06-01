import Foundation
import Zip
import RealmSwift

enum ErrorMessage: String, Error {
    case notNost = "잘못된 nost파일 형식입니다."
}

func zipAlbumDirectory(AlbumCoverName: String) throws -> URL? {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
    //압축을 할 앨범 directory url
    let dirURL = documentDirectory.appendingPathComponent(AlbumCoverName)
    //nost로 변환할 direcotry
    do {
        if !FileManager.default.fileExists(atPath: documentDirectory.appendingPathComponent("nostFiles").path) {
            try FileManager.default.createDirectory(at: documentDirectory.appendingPathComponent("nostFiles"), withIntermediateDirectories: true, attributes: nil)
        }
    } catch let error as NSError {
        throw error
    }
    
    let nostURL = documentDirectory.appendingPathComponent("nostFiles").appendingPathComponent("\(AlbumCoverName).nost")
    do {
        try exportAlbumInfo(coverData: AlbumCoverName)
    } catch let error as NSError {
        throw error
    }
    do {
        let files = try FileManager.default.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: nil)
        let zipFilePath = documentDirectory.appendingPathComponent("nostFiles").appendingPathComponent("\(AlbumCoverName).zip")
        try Zip.zipFiles(paths: files, zipFilePath: zipFilePath, password: nil, progress: nil)
        do {
            if FileManager.default.fileExists(atPath: nostURL.path) {
                do {
                    try FileManager.default.removeItem(at: nostURL)
                    print("nost파일 삭제 완료")
                } catch let error as NSError {
                    print("nost파일을 삭제하지 못했습니다.")
                    throw error
                }
            }
            do {
                //zip -> nost write
                if var data = try? Data(contentsOf: zipFilePath) {
                    let stringToCheck = "$"
                    let checkData = stringToCheck.data(using: .utf8)
                    data.append(checkData!)
                    let newURL = URL(filePath: nostURL.path)
                    try? data.write(to: newURL)
                    try FileManager.default.removeItem(at: zipFilePath)
                } else {
                    print("Error rewrite file")
                }
            } catch let error as NSError {
                throw error
            }
        }
    } catch let error {
        print("Something went wrong")
        throw error
    }
    do {
        try FileManager.default.removeItem(at: dirURL.appendingPathComponent("\(AlbumCoverName)_coverInfo.txt"))
        try FileManager.default.removeItem(at: dirURL.appendingPathComponent("\(AlbumCoverName)_imageNameInfo.txt"))
        try FileManager.default.removeItem(at: dirURL.appendingPathComponent("\(AlbumCoverName)_imageTextInfo.txt"))
        try FileManager.default.removeItem(at: dirURL.appendingPathComponent("\(AlbumCoverName)_Info.txt"))
    } catch let error {
        print("Error remove txt file")
        throw error
    }
    return nostURL
}

func exportAlbumInfo(coverData: String) throws {
    let realm = try! Realm()
    let albumCoverData = realm.objects(albumCover.self).filter("albumName = '\(coverData)'")
    let albumData = realm.objects(album.self).filter("AlbumTitle = '\(coverData)'")
    let albumInfo = realm.objects(albumsInfo.self).filter("id = \(albumCoverData.first!.id)")
    var arrCoverInfo = [String]()
    var arrImageName = [String]()
    var arrImageText = [String]()
    var arrAlbumInfo = [String]()
    var arrTextCount = [String]()
    // albumCoverData
    arrCoverInfo.append("\(albumCoverData.first!.id)")
    arrCoverInfo.append("\(albumCoverData.first!.coverImageName)")
    arrCoverInfo.append("\(albumCoverData.first!.isCustomCover)")
    
    // albumData
    for album in albumData {
        arrImageText.append("\(album.ImageText)")
        arrImageName.append("\(album.ImageName)")
    }
    for iText in arrImageText {
        let count = iText.components(separatedBy: "\n")
        if iText == "" {
            arrTextCount.append(String(count.count - 1))
        } else {
            arrTextCount.append(String(count.count))
        }
    }
    print(arrTextCount)
    
    // albumInfoData
    arrAlbumInfo.append("\(albumInfo.first!.id)")
    arrAlbumInfo.append(String(albumInfo.first!.numberOfPictures))
    arrAlbumInfo.append(albumInfo.first!.dateOfCreation)
    arrAlbumInfo.append(albumInfo.first!.font)
    arrAlbumInfo.append(String(albumInfo.first!.firstPageSetting))
    
    let imageTextTable = arrTextCount.joined(separator: " ")
    arrImageText.insert(imageTextTable, at: 0)
    
    let albumCoverInfo = arrCoverInfo.joined(separator: "\n")
    let imageNameInfo = arrImageName.joined(separator: "\n")
    let imageTextInfo = arrImageText.joined(separator: "\n")
    let albumInfoText = arrAlbumInfo.joined(separator: "\n")
    
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let dirURL = documentDirectory.appendingPathComponent(coverData)
    
    let albumCoverURL = dirURL.appendingPathComponent("\(coverData)_coverInfo.txt")
    let nameInfoURL = dirURL.appendingPathComponent("\(coverData)_imageNameInfo.txt")
    let textInfoURL = dirURL.appendingPathComponent("\(coverData)_imageTextInfo.txt")
    let albumInfoURL = dirURL.appendingPathComponent("\(coverData)_Info.txt")
    
    if FileManager.default.fileExists(atPath: albumCoverURL.path) {
        do {
            try FileManager.default.removeItem(at: albumCoverURL)
        } catch let error as NSError {
            print("Error occur :: \(error)")
        }
    }
    if FileManager.default.fileExists(atPath: nameInfoURL.path) {
        do {
            try FileManager.default.removeItem(at: nameInfoURL)
        } catch let error as NSError {
            print("Error occur :: \(error)")
        }
    }
    if FileManager.default.fileExists(atPath: textInfoURL.path) {
        do {
            try FileManager.default.removeItem(at: textInfoURL)
        } catch let error as NSError {
            print("Error occur :: \(error)")
        }
    }
    if FileManager.default.fileExists(atPath: albumInfoURL.path) {
        do {
            try FileManager.default.removeItem(at: albumInfoURL)
        } catch let error as NSError {
            print("Error occur :: \(error)")
        }
    }
    
    do {
        try albumCoverInfo.write(to: albumCoverURL, atomically: true, encoding: .utf8)
        try imageNameInfo.write(to: nameInfoURL, atomically: true, encoding: .utf8)
        try imageTextInfo.write(to: textInfoURL, atomically: true, encoding: .utf8)
        try albumInfoText.write(to: albumInfoURL, atomically: true, encoding: .utf8)
    } catch let error {
        throw error
    }
    
}

func unzipAlbumDirectory(AlbumCoverName: String, shareFilePath: URL, checkFileProvider: Bool) throws {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
    // (앨범 이름).zip file을 만들 경로
    let zipURL = documentDirectory.appendingPathComponent("\(AlbumCoverName).zip")
    // unzip한 파일들 저장할 디렉토리 생성
    do {
        let data = try Data(contentsOf: shareFilePath)
        let checkByte = data.last
        if let checkByte = checkByte {
            if checkByte == UInt8(ascii: "$") {
                print("올바른 파일입니다.")
            } else {
                throw ErrorMessage.notNost
            }
        }
        try data.write(to: zipURL)
        try Zip.unzipFile(zipURL, destination: zipURL.deletingPathExtension(), overwrite: true, password: nil)
        try changeIfModifyName(albumCoverName: AlbumCoverName)
        //zipURL == sandbox에서 documents내 zip
        try FileManager.default.removeItem(at: zipURL)
        //filePath == simulator의 경우 tmp/com....NostelgiAlbum-Inbox
        //device의 경우 Inbox/내 .nost파일
        if checkFileProvider == false {
            try FileManager.default.removeItem(at: shareFilePath)
        }
    } catch let error {
        throw error
    }
    
}

// 공유받은 album realm에 write
func importAlbumInfo(albumCoverName: String, useForShare: Bool) throws {
    let realm = try! Realm()
    
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    // albumCover
    let coverInfoURL = documentDirectory.appendingPathComponent(albumCoverName).appendingPathComponent("\(albumCoverName)_coverInfo.txt")
    // albumName
    let nameInfoURL = documentDirectory.appendingPathComponent(albumCoverName).appendingPathComponent("\(albumCoverName)_imageNameInfo.txt")
    // albumText
    let textInfoURL = documentDirectory.appendingPathComponent(albumCoverName).appendingPathComponent("\(albumCoverName)_imageTextInfo.txt")
    // albumInfo
    // numberofPictures
    // dateOfCreation
    let albumInfoURL = documentDirectory.appendingPathComponent(albumCoverName).appendingPathComponent("\(albumCoverName)_Info.txt")
    
    var arrCoverInfo = [String]()
    var arrImageName = [String]()
    var arrImageText = [String]()
    var arrAlbumInfo = [String]()
    //Reading text file
    do {
        let coverInfoContents = try String(contentsOfFile: coverInfoURL.path, encoding: .utf8)
        let imageNameContents = try String(contentsOfFile: nameInfoURL.path, encoding: .utf8)
        let textInfoContents = try String(contentsOfFile: textInfoURL.path, encoding: .utf8)
        let albumInfoContents = try String(contentsOfFile: albumInfoURL.path, encoding: .utf8)
        
        let coverInfos = coverInfoContents.split(separator: "\n")
        let names = imageNameContents.split(separator: "\n")
        let texts = textInfoContents.split(separator: "\n")
        let infos = albumInfoContents.split(separator: "\n")
        
        for coverInfo in coverInfos {
            arrCoverInfo.append("\(coverInfo)")
        }
        for name in names {
            arrImageName.append("\(name)")
        }
        
        var textCount = 1
        let arr = texts.first!.split(separator: " ").map{ Int($0)! }
        let strArr = texts.map{ String($0) }
        for i in arr {
            var str = ""
            if i > 0 {
                for check in 1...i {
                    if check != i {
                        str.append("\(strArr[textCount])\n")
                    } else {
                        str.append("\(strArr[textCount])")
                    }
                    textCount += 1
                }
            }
            arrImageText.append("\(str)")
        }
        
        for info in infos {
            arrAlbumInfo.append("\(info)")
        }
    } catch let error {
        print("File read error")
        throw error
    }
    
    let shareAlbumCover = albumCover()
    if useForShare == true {
        shareAlbumCover.incrementIndex()
    } else {
        shareAlbumCover.id = Int(arrCoverInfo[0])!
    }
    shareAlbumCover.coverImageName = arrCoverInfo[1]
    shareAlbumCover.isCustomCover = Bool(arrCoverInfo[2])!
    shareAlbumCover.albumName = albumCoverName
    
    
    let shareAlbumInfo = albumsInfo()
    if useForShare == true {
        shareAlbumInfo.incrementIndex()
    } else {
        shareAlbumInfo.id = Int(arrAlbumInfo[0])!
    }
    shareAlbumInfo.numberOfPictures = Int(arrAlbumInfo[1])!
    shareAlbumInfo.dateOfCreation = arrAlbumInfo[2]
    shareAlbumInfo.font = arrAlbumInfo[3]
    shareAlbumInfo.firstPageSetting = Int(arrAlbumInfo[4])!
    
    if arrImageName.count != 0 {
        do {
            try realm.write {
                for i in 1...arrImageName.count {
                    let shareAlbumImage = album()
                    shareAlbumImage.ImageName = arrImageName[i - 1]
                    shareAlbumImage.ImageText = arrImageText[i - 1]
                    shareAlbumImage.perAlbumIndex = i
                    shareAlbumImage.AlbumTitle = albumCoverName
                    shareAlbumImage.index = shareAlbumCover.id
                    realm.add(shareAlbumImage)
                }
            }
        } catch let error {
            throw error
        }
    }
    do {
        // Write
        try realm.write{
            realm.add(shareAlbumCover)
            realm.add(shareAlbumInfo)
        }
    } catch let error {
        throw error
    }
    // Remove text file
    do {
        try FileManager.default.removeItem(at: coverInfoURL)
        try FileManager.default.removeItem(at: nameInfoURL)
        try FileManager.default.removeItem(at: textInfoURL)
        try FileManager.default.removeItem(at: albumInfoURL)
    } catch let error {
        print("Error removing txt")
        throw error
    }
}

func checkExistedAlbum(albumCoverName: String) -> Bool {
    let realm = try! Realm()
    let albumCover = realm.objects(albumCover.self)
    for data in albumCover {
        if data.albumName == albumCoverName {
            return true
        }
    }
    return false
}

// - MARK: 앨범이름이 중복되었는지 확인하고 중복되었을 경우 앨범 디렉토리내 파일들 이름 변경
func changeIfModifyName(albumCoverName: String) throws {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let albumDir = documentDirectory.appendingPathComponent(albumCoverName)
    let files: [URL]
    do {
        files = try FileManager.default.contentsOfDirectory(at: albumDir, includingPropertiesForKeys: nil)
        let filesStr = try FileManager.default.contentsOfDirectory(atPath: albumDir.path)
        let originName = filesStr.first!.split(separator: "_")
        if (originName.first)! != albumCoverName {
            for i in 0...files.count - 1 {
                let replaceStr = filesStr[i].replacingOccurrences(of: originName.first!, with: albumCoverName)
                do {
                    try FileManager.default.moveItem(atPath: files[i].path, toPath: albumDir.appendingPathComponent(replaceStr).path)
                } catch let error {
                    throw error
                }
            }
        }
    } catch let error {
        print("files error")
        throw error
    }
}

// 기존에 강제 종료 등으로 인한 nost & zip파일이 남아있을 경우 삭제
func nostFileRemove() {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    if FileManager.default.fileExists(atPath: documentDirectory.appendingPathComponent("nostFiles").path) {
        do {
            try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("nostFiles"))
        } catch {
            print("nostFiles Directory delete error")
        }
    }
}

// 카카오톡과 같은 외부 링크로 파일 받을 시 생기는 Inbox에서 extTemp로 이동시킨 파일들 삭제
func externalFileRemove() {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    if FileManager.default.fileExists(atPath: documentDirectory.appendingPathComponent("extTemp").path)
    {
        do {
            try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent("extTemp"))
        } catch {
            print("extTemp Directory delete error")
        }
    }
}
