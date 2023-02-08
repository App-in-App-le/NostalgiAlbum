import UIKit
import UniformTypeIdentifiers
import Zip
import RealmSwift

class ShareViewController: UIViewController, UIDocumentPickerDelegate {

    
    @IBOutlet weak var albumInfoLabel: UILabel!
    var filePath: URL?
    var collectionViewInHome : UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadingAlbumInfo()
    }
    @IBAction func openInButtonTapped(_ sender: Any) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let AlbumCoverName = filePath?.deletingPathExtension().lastPathComponent
        let zipURL = documentDirectory.appendingPathComponent("\(AlbumCoverName!).zip")
        print("zipURL",zipURL.path)
        if let data = try? Data(contentsOf: filePath!) {
            let newURL = URL(filePath: zipURL.path)
            try? data.write(to: zipURL)
            print("newURL", newURL.path)
            do {
                let _: () = try Zip.unzipFile(zipURL, destination: zipURL.deletingLastPathComponent(), overwrite: true, password: nil)
                try FileManager.default.removeItem(at: newURL)
            } catch {
                print("Something went wrong")
            }
        } else {
            print("Error rewrite zip")
        }
        addShareAlbum(albumURL: filePath!)
        collectionViewInHome.reloadData()
        //self.dismiss(animated: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadingAlbumInfo() {
        let AlbumCoverName = filePath?.deletingPathExtension().lastPathComponent
        albumInfoLabel.text = "'\(AlbumCoverName!)'을 추가하시겠습니까?"
    }
}

func addShareAlbum(albumURL: URL) {
    let realm = try! Realm()
    
    guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    
    let albumCoverName = albumURL.deletingPathExtension().lastPathComponent
    
    let nameInfoURL = documentDirectory.appendingPathComponent(albumCoverName).appendingPathComponent("\(albumCoverName)imageNameInfo.txt")
    
    let textInfoURL = documentDirectory.appendingPathComponent(albumCoverName).appendingPathComponent("\(albumCoverName)imageTextInfo.txt")
    
    let albumInfoURL = documentDirectory.appendingPathComponent(albumCoverName).appendingPathComponent("\(albumCoverName)Info.txt")
    
    var arrImageName = [String]()
    var arrImageText = [String]()
    var arrAlbumInfo = [String]()
    
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
    
    try! realm.write{
        realm.add(shareAlbumCover)
        realm.add(shareAlbumInfo)
    }
    do {
        try FileManager.default.removeItem(at: nameInfoURL)
        try FileManager.default.removeItem(at: textInfoURL)
        try FileManager.default.removeItem(at: albumInfoURL)
    } catch {
        print("Error removing txt")
    }
}
