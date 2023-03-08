import Foundation
import Zip
import RealmSwift

func zipAlbumDirectory(AlbumCoverName: String) -> URL? {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil}
    //압축을 할 앨범 directory url
    let dirURL = documentDirectory.appendingPathComponent(AlbumCoverName)
    //nost로 변환할 direcotry
    let nostURL = documentDirectory.appendingPathComponent("\(AlbumCoverName).nost")
    exportAlbumInfo(coverData: AlbumCoverName)
    do {
        let files = try FileManager.default.contentsOfDirectory(at: dirURL, includingPropertiesForKeys: nil)
        let zipFilePath = documentDirectory.appendingPathComponent("\(AlbumCoverName).zip")
        try Zip.zipFiles(paths: files, zipFilePath: zipFilePath, password: nil, progress: nil)
        do {
            if FileManager.default.fileExists(atPath: nostURL.path) {
                do {
                    try FileManager.default.removeItem(at: nostURL)
                    print("nost파일 삭제 완료")
                } catch {
                    print("nost파일을 삭제하지 못했습니다.")
                }
            }
            //zip -> nost write
            if let data = try? Data(contentsOf: zipFilePath) {
                let newURL = URL(filePath: nostURL.path)
                try? data.write(to: newURL)
                try FileManager.default.removeItem(at: zipFilePath)
            } else {
                print("Error rewrite file")
            }
        }
    } catch {
        print("Something went wrong")
    }
    do {
        try FileManager.default.removeItem(at: dirURL.appendingPathComponent("\(AlbumCoverName)imageNameInfo.txt"))
        try FileManager.default.removeItem(at: dirURL.appendingPathComponent("\(AlbumCoverName)imageTextInfo.txt"))
        try FileManager.default.removeItem(at: dirURL.appendingPathComponent("\(AlbumCoverName)Info.txt"))
    } catch {
        print("Error remove txt file")
    }
        return nostURL
}

func unzipAlbumDirectory(AlbumCoverName: String, shareFilePath: URL) {
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
    //(앨범 이름).zip file을 만들 경로
    let zipURL = documentDirectory.appendingPathComponent("\(AlbumCoverName).zip")
    print("sharepath",shareFilePath.path)
    print("zipURL",zipURL.path)
    if let data = try? Data(contentsOf: shareFilePath) {
        try? data.write(to: zipURL)
        do {
            try Zip.unzipFile(zipURL, destination: zipURL.deletingPathExtension(), overwrite: true, password: nil)
            changeIfModifyName(albumCoverName: AlbumCoverName)
            //zipURL == sandbox에서 documents내 zip
            try FileManager.default.removeItem(at: zipURL)
            //filePath == simulator의 경우 tmp/com....NostelgiAlbum-Inbox
            //device의 경우 Inbox/내 .nost파일
            try FileManager.default.removeItem(at: shareFilePath)
        } catch {
            print("Something went wrong")
        }
    } else {
        print("Error rewrite zip")
    }
    
    
}

func exportAlbumInfo(coverData: String) {
    let realm = try! Realm()
    let albumData = realm.objects(album.self).filter("AlbumTitle = '\(coverData)'")
    let albumInfo = realm.objects(albumsInfo.self).filter("id = \(albumData.first!.index)")
    var arrImageName = [String]()
    var arrImageText = [String]()
    var arrAlbumInfo = [String]()
    
    for album in albumData {
        arrImageText.append("\(album.ImageText)")
        arrImageName.append("\(album.ImageName)")
    }
    
    arrAlbumInfo.append(String(albumInfo.first!.numberOfPictures))
    arrAlbumInfo.append(albumInfo.first!.dateOfCreation)
    let imageNameInfo = arrImageName.joined(separator: "\n")
    let imageTextInfo = arrImageText.joined(separator: "\n")
    let albumInfoText = arrAlbumInfo.joined(separator: "\n")
    
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let dirURL = documentDirectory.appendingPathComponent(coverData)
    let nameInfoURL = dirURL.appendingPathComponent("\(coverData)_imageNameInfo.txt")
    let textInfoURL = dirURL.appendingPathComponent("\(coverData)_imageTextInfo.txt")
    let albumInfoURL = dirURL.appendingPathComponent("\(coverData)_Info.txt")
    
    do {
        try imageNameInfo.write(to: nameInfoURL, atomically: true, encoding: .utf8)
        try imageTextInfo.write(to: textInfoURL, atomically: true, encoding: .utf8)
        try albumInfoText.write(to: albumInfoURL, atomically: true, encoding: .utf8)
    } catch {
        print("Error writing file")
    }
    
}

//공유받은 album realm에 write
func importAlbumInfo(albumCoverName: String) {
    let realm = try! Realm()
    
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        //albumName
    let nameInfoURL = documentDirectory.appendingPathComponent(albumCoverName).appendingPathComponent("\(albumCoverName)_imageNameInfo.txt")
    //albumText
    let textInfoURL = documentDirectory.appendingPathComponent(albumCoverName).appendingPathComponent("\(albumCoverName)_imageTextInfo.txt")
    //albumInfo
    //numberofPictures
    //dateOfCreation
    let albumInfoURL = documentDirectory.appendingPathComponent(albumCoverName).appendingPathComponent("\(albumCoverName)_Info.txt")
    
    var arrImageName = [String]()
    var arrImageText = [String]()
    var arrAlbumInfo = [String]()
    //Reading text file
    do {
        let imageNameContents = try String(contentsOfFile: nameInfoURL.path, encoding: .utf8)
        let textInfoContents = try String(contentsOfFile: textInfoURL.path, encoding: .utf8)
        let albumInfoContents = try String(contentsOfFile: albumInfoURL.path, encoding: .utf8)
        let names = imageNameContents.split(separator: "\n")
        let texts = textInfoContents.split(separator: "\n")
        let infos = albumInfoContents.split(separator: "\n")
        for name in names {
            arrImageName.append("\(name)")
        }
        for text in texts {
            arrImageText.append("\(text)")
        }
        for info in infos {
            arrAlbumInfo.append("\(info)")
        }
    } catch {
        print("File read error")
    }
    let shareAlbumCover = albumCover()
    shareAlbumCover.incrementIndex()
    shareAlbumCover.albumName = albumCoverName
    shareAlbumCover.coverImageName = "Red"
    
    let shareAlbumInfo = albumsInfo()
    shareAlbumInfo.numberOfPictures = Int(arrAlbumInfo[0])!
    shareAlbumInfo.dateOfCreation = arrAlbumInfo[1]
    shareAlbumInfo.incrementIndex()
    
    
    for i in 1...arrImageName.count {
        let shareAlbumImage = album()
        shareAlbumImage.ImageName = arrImageName[i - 1]
        shareAlbumImage.ImageText = arrImageText[i - 1]
        shareAlbumImage.perAlbumIndex = i
        shareAlbumImage.AlbumTitle = albumCoverName
        shareAlbumImage.index = shareAlbumCover.id
        try! realm.write{
            realm.add(shareAlbumImage)
        }
    }
    //Write!
    try! realm.write{
        realm.add(shareAlbumCover)
        realm.add(shareAlbumInfo)
    }
    //Remove text file
    do {
        try FileManager.default.removeItem(at: nameInfoURL)
        try FileManager.default.removeItem(at: textInfoURL)
        try FileManager.default.removeItem(at: albumInfoURL)
    } catch {
        print("Error removing txt")
    }
}
/*
 */
func checkExistedAlbum(albumCoverName: String) -> Bool {
    let realm = try! Realm()
    let album = realm.objects(album.self)
    for data in album {
        if data.AlbumTitle == albumCoverName {
            return true
        }
    }
    return false
}

// - MARK: 앨범이름이 중복되었는지 확인하고 중복되었을 경우 앨범 디렉토리내 파일들 이름 변경
func changeIfModifyName(albumCoverName: String) {
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
                try FileManager.default.moveItem(atPath: files[i].path, toPath: albumDir.appendingPathComponent(replaceStr).path)
            }
        }
    } catch {
        print("files error")
    }
}

