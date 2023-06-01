import UIKit
import RealmSwift
import Zip

class ShareViewController: UIViewController, UIDocumentPickerDelegate {
    // MARK: - Properties
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var editTitle: UILabel!
    @IBOutlet weak var albumName: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancleButton: UIButton!
    @IBOutlet weak var divideLine: UILabel!
    weak var collectionViewInHome : UICollectionView!
    let realm = try! Realm()
    var filePath: URL?
    var existedAlbum : Bool!
    var albumCoverName : String!
    var checkFileProvider : Bool!
    
    // MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCoverName = filePath?.deletingPathExtension().lastPathComponent.precomposedStringWithCanonicalMapping
        if albumCoverName?.count ?? 0 > 10 {
            albumCoverName = String(albumCoverName?.prefix(9) ?? "")
        }
        albumName.text = albumCoverName
        albumCoverName = albumName.text
        albumName.delegate = self //textfield 클릭 시 다른 뷰로 전환되는 delegate 추가
        loadingAlbumInfo()
        setSubViews()
        setThemeColor()
    }
    
    // MARK: - Methods
    func setSubViews() {
        // editView
        editView.clipsToBounds = true
        editView.layer.cornerRadius = 15
        // createButton
        createButton.layer.cornerRadius = 8
        // cancleButton
        cancleButton.layer.cornerRadius = 8
    }
    
    @IBAction func openInButtonTapped(_ sender: Any) {
        //.nost file URL에서 .nost앞 앨범 이름만 따옴
        if !existedAlbum {
            do {
                try unzipAlbumDirectory(AlbumCoverName: albumCoverName, shareFilePath: filePath!, checkFileProvider: checkFileProvider)
            } catch let error {
                NSErrorHandling_Alert(error: error, vc: self)
                // MARK: - Document에 저장된 album Directory 삭제
                guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
                if FileManager.default.fileExists(atPath: documentDirectory.appendingPathComponent(albumCoverName).path) {
                    do {
                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent(albumCoverName))
                    } catch let error as NSError{
                        print("Error Occur In ShareViewController :: \(error)")
                    }
                }
                return
            }
            do {
                albumCoverName = albumName.text
                //realm에 공유받은 album정보 write
                try importAlbumInfo(albumCoverName: albumCoverName, useForShare: true)
            } catch let error {
                NSErrorHandling_Alert(error: error, vc: self)
                // MARK: - RealmDB에 들어간 정보 삭제 + Document에 저장된 album Directory 삭제
                // Realm에 있는 정보 삭제
                // Realm에 입력되는 순서 -> album, albumsInfo, albumCover
                let albums = realm.objects(album.self).filter("AlbumTitle = \(albumCoverName!)")
                if let firstPicture = albums.first {
                    let albumId = firstPicture.index
                    // album 정보 삭제
                    for album in albums {
                        do {
                            try realm.write {
                                realm.delete(album)
                            }
                        } catch let error as NSError{
                            print("Error occur in ShareViewController [OpenInButtonTapped] :: \(error)")
                        }
                    }
                    // albumsInfo 정보 삭제
                    if let albumsInfo = realm.objects(albumsInfo.self).filter("id = \(albumId)").first {
                        do {
                            try realm.write {
                                realm.delete(albumsInfo)
                            }
                        } catch let error as NSError{
                            print("Error occur in ShareViewController [OpenInButtonTapped] :: \(error)")
                        }
                    }
                    // albumCover 정보 삭제
                    if let albumCover = realm.objects(albumCover.self).filter("id = \(albumId)").first {
                        do {
                            try realm.write {
                                realm.delete(albumCover)
                            }
                        } catch let error as NSError{
                            print("Error occur in ShareViewController [OpenInButtonTapped] :: \(error)")
                        }
                    }
                }
                // Document에 생성된 Album Directory 삭제
                guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else {return}
                if FileManager.default.fileExists(atPath: documentDirectory.appendingPathComponent(albumCoverName).path) {
                    do {
                        try FileManager.default.removeItem(at: documentDirectory.appendingPathComponent(albumCoverName))
                    } catch let error as NSError{
                        print("Error Occur In ShareViewController :: \(error)")
                    }
                }
                return
            }
            //album reload
            collectionViewInHome.reloadData()
            self.dismiss(animated: false)
        } else {
            let textAlert = UIAlertController(title: "중복된 이름", message: "이미 존재하는 앨범입니다. 이름을 바꿔주세요.", preferredStyle: UIAlertController.Style.alert)
            present(textAlert, animated: true){
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.didTappedOutside(_:)))
                textAlert.view.superview?.isUserInteractionEnabled = true
                textAlert.view.superview?.addGestureRecognizer(tap)
            }
        }
    }
    
    @IBAction func closeInButtonTapped(_ sender: Any) {
        if !checkFileProvider {
            do{
                try FileManager.default.removeItem(at: filePath!)
            } catch let error {
                print("NSError Occur :: \(error)")
            }
        }
        self.dismiss(animated: false)
    }

    func loadingAlbumInfo() {
        if checkExistedAlbum(albumCoverName: albumCoverName) {
            existedAlbum = true
        } else {
            existedAlbum = false
        }
    }
        
    @objc func didTappedOutside(_ sender: UITapGestureRecognizer) {
        dismiss(animated: false, completion: nil)
    }
    
}
// -MARK: shareView에서 textfield 클릭 시 앨범 이름을 변경하는 AlbumRenameViewController를 present
extension ShareViewController: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        guard let renameVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumRenameViewController") as? AlbumRenameViewController else { return }
        renameVC.albumCoverName = albumCoverName
        renameVC.filePath = filePath
        renameVC.shareVC = self
//        renameVC.modalPresentationStyle = .overFullScreen
        renameVC.modalPresentationStyle = .currentContext
        renameVC.modalTransitionStyle = .crossDissolve
        self.present(renameVC, animated: true)
    }
}

extension String.Encoding {
    static let euc_kr = String.Encoding(rawValue: CFStringConvertEncodingToNSStringEncoding(CFStringEncoding(CFStringEncodings.EUC_KR.rawValue)))
}

extension String {
    func bytesByRemovingPercentEncoding(using encoding: String.Encoding) -> Data {
        struct My {
            static let regex = try! NSRegularExpression(pattern: "(%[0-9A-F]{2})|(.)", options: .caseInsensitive)
        }
        var bytes = Data()
        let nsSelf = self as NSString
        for match in My.regex.matches(in: self, range: NSRange(0..<self.utf16.count)) {
            if match.range(at:1).location != NSNotFound {
                let hexString = nsSelf.substring(with: NSMakeRange(match.range(at:1).location+1, 2))
                bytes.append(UInt8(hexString, radix: 16)!)
            } else {
                let singleChar = nsSelf.substring(with: match.range(at:2))
                bytes.append(singleChar.data(using: encoding) ?? "?".data(using: .ascii)!)
            }
        }
        return bytes
    }
    
    func removingPercentEncoding(using encoding: String.Encoding) -> String? {
        return String(data: bytesByRemovingPercentEncoding(using: encoding), encoding: encoding)
    }
}
