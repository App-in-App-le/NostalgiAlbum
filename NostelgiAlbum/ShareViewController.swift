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
        //.nost file URL에서 .nost앞 앨범 이름만 따옴
        let AlbumCoverName = filePath?.deletingPathExtension().lastPathComponent
        unzipAlbumDirectory(AlbumCoverName: AlbumCoverName!, shareFilePath: filePath!)
        //realm에 공유받은 album정보 write
        importAlbumInfo(albumURL: filePath!)
        //album reload
        collectionViewInHome.reloadData()
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadingAlbumInfo() {
        let AlbumCoverName = filePath?.deletingPathExtension().lastPathComponent
        albumInfoLabel.text = "'\(AlbumCoverName!)'을 추가하시겠습니까?"
    }
}
