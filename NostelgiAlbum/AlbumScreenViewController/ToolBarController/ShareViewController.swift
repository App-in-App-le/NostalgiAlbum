import UIKit
import Zip

class ShareViewController: UIViewController, UIDocumentPickerDelegate {
    
    @IBOutlet weak var albumShareButton: UIButton!
    var filePath: URL?
    var collectionViewInHome : UICollectionView!
    var existedAlbum : Bool!
    var albumCoverName : String!
    // 기존 button이었던 object를 Textfield로 변경
    @IBOutlet weak var albumCoverText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        albumCoverName = filePath?.deletingPathExtension().lastPathComponent
        albumCoverText.text = albumCoverName
        albumCoverText.delegate = self //textfield 클릭 시 다른 뷰로 전환되는 delegate 추가
        loadingAlbumInfo()
    }
    
    @IBAction func openInButtonTapped(_ sender: Any) {
        var titleText = ""
        var messageText = ""
        let errorAlert = UIAlertController(title: titleText, message: messageText, preferredStyle: .alert)
        errorAlert.setFont(font: nil, title: titleText, message: messageText)
        let okAction = UIAlertAction(title: "확인", style: .default) { action in
            errorAlert.dismiss(animated: false)
        }
        errorAlert.addAction(okAction)
        //.nost file URL에서 .nost앞 앨범 이름만 따옴
        if(!existedAlbum) {
            do {
                try unzipAlbumDirectory(AlbumCoverName: albumCoverName, shareFilePath: filePath!)
            } catch let error {
                switch error {
                case ZipError.unzipFail:
                    titleText = "압축 해제 실패"
                    messageText = "압축 해제에 실패했습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileWriteFileExistsError:
                    titleText = "기존 파일 존재"
                    messageText = "기존 파일이 존재하고 있습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileReadUnknownError:
                    titleText = "파일 읽기 에러"
                    messageText = "파일을 읽을 수 없습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileReadInvalidFileNameError:
                    titleText = "잘못된 이름"
                    messageText = "읽을 수 없는 파일 이름입니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileWriteInvalidFileNameError:
                    titleText = "잘못된 이름"
                    messageText = "파일 이름이 잘못되었습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileWriteOutOfSpaceError:
                    titleText = "용량 부족"
                    messageText = "디바이스에 용량이 부족합니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileWriteNoPermissionError:
                    titleText = "권한 부재"
                    messageText = "파일을 작성할 권한이 없습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileReadNoPermissionError:
                    titleText = "권한 부재"
                    messageText = "파일을 읽을 권한이 없습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileNoSuchFileError:
                    titleText = "파일 부재"
                    messageText = "파일을 찾을 수 없습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                default:
                    titleText = "공유 실패"
                    messageText = "공유 파일 받기에 실패했습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                }
            }
            do {
                //realm에 공유받은 album정보 write
                try importAlbumInfo(albumCoverName: albumCoverName, useForShare: true)
            } catch let error {
                switch error {
                case ZipError.unzipFail:
                    titleText = "압축 해제 실패"
                    messageText = "압축 해제에 실패했습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileWriteFileExistsError:
                    titleText = "기존 파일 존재"
                    messageText = "기존 파일이 존재하고 있습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileReadUnknownError:
                    titleText = "파일 읽기 에러"
                    messageText = "파일을 읽을 수 없습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileReadInvalidFileNameError:
                    titleText = "잘못된 이름"
                    messageText = "읽을 수 없는 파일 이름입니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileWriteInvalidFileNameError:
                    titleText = "잘못된 이름"
                    messageText = "파일 이름이 잘못되었습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileWriteOutOfSpaceError:
                    titleText = "용량 부족"
                    messageText = "디바이스에 용량이 부족합니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileWriteNoPermissionError:
                    titleText = "권한 부재"
                    messageText = "파일을 작성할 권한이 없습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileReadNoPermissionError:
                    titleText = "권한 부재"
                    messageText = "파일을 읽을 권한이 없습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                case let nsError as NSError where nsError.code == NSFileNoSuchFileError:
                    titleText = "파일 부재"
                    messageText = "파일을 찾을 수 없습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                default:
                    titleText = "공유 실패"
                    messageText = "공유 파일 받기에 실패했습니다."
                    present(errorAlert, animated: true) {
                        self.dismiss(animated: true)
                    }
                    break
                }
            }
            //album reload
            collectionViewInHome.reloadData()
            //self.navigationController?.popViewController(animated: true)
            self.dismiss(animated: true)
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
        self.dismiss(animated: true)
    }
    
    @IBAction func changeAlbumName(_ sender: Any) {
        guard let renameVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumRenameViewController") as? AlbumRenameViewController else { return }
        renameVC.albumCoverName = albumCoverName
        renameVC.filePath = filePath
        renameVC.shareVC = self
        renameVC.modalPresentationStyle = .overFullScreen
        self.present(renameVC, animated: true)
    }

    func loadingAlbumInfo() {
        if checkExistedAlbum(albumCoverName: albumCoverName) {
            existedAlbum = true
        } else {
            existedAlbum = false
        }
    }
        
    @objc func didTappedOutside(_ sender: UITapGestureRecognizer) {
        dismiss(animated: true, completion: nil)
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
