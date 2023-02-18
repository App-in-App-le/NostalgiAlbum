import UIKit

class ShareViewController: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var albumInfoLabel: UILabel!
    @IBOutlet weak var albumShareButton: UIButton!
    var filePath: URL?
    var collectionViewInHome : UICollectionView!
    var existedAlbum : Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.albumInfoLabel.numberOfLines = 0
        loadingAlbumInfo()
    }
    
    @IBAction func openInButtonTapped(_ sender: Any) {
        //.nost file URL에서 .nost앞 앨범 이름만 따옴
        let AlbumCoverName = filePath?.deletingPathExtension().lastPathComponent
        if(!existedAlbum) {
            unzipAlbumDirectory(AlbumCoverName: AlbumCoverName!, shareFilePath: filePath!)
            //realm에 공유받은 album정보 write
            importAlbumInfo(albumURL: filePath!)
            //album reload
            collectionViewInHome.reloadData()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    func loadingAlbumInfo() {
        let AlbumCoverName = filePath?.deletingPathExtension().lastPathComponent
        if checkExistedAlbum(albumCoverName: AlbumCoverName!) {
            albumInfoLabel.text = "'\(AlbumCoverName!)'은 이미 존재하는 앨범 제목입니다. 앨범 제목을 바꾸세요"
            existedAlbum = true
        } else {
            albumInfoLabel.text = "'\(AlbumCoverName!)'을 추가하시겠습니까?"
            existedAlbum = false
        }
    }
}
