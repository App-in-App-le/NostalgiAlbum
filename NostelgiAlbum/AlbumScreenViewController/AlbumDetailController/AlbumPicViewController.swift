import UIKit

class AlbumPicViewController: UIViewController {

    @IBOutlet weak var picName: UILabel!
    @IBOutlet weak var picText: UILabel!
    @IBOutlet weak var picImage: UIButton!
    @IBOutlet weak var settingBtn: UIButton!
    var picture: album!
    var collectionViewInAlbum : UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        picName.text = picture.ImageName
        picText.text = picture.ImageText
        picImage.setTitle("", for: .normal)
        let totalPath = "\(picture.AlbumTitle)_\(picture.perAlbumIndex)"
        picImage.setImage(loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle)?.resize(newWidth: picImage.frame.width, newHeight: (picImage.frame.height)), for: .normal)
        settingBtn.setTitle("", for: .normal)
        settingBtn.setImage(UIImage(systemName: "gearshape"), for: .normal)
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(exitSwipe(_:)))
        swipeRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    @objc func exitSwipe(_ sender :UISwipeGestureRecognizer){
        if sender.direction == .down{
            self.dismiss(animated: true)
        }
    }
    
    @IBAction func settingPicture(_ sender: Any) {
        guard let editVC = self.storyboard?.instantiateViewController(withIdentifier: "AlbumEditViewController") as? AlbumEditViewController else { return }
        guard let picVC = self.presentingViewController else { return }
        editVC.picture = picture
        editVC.collectionViewInAlbum = collectionViewInAlbum
        //editVC.editPicture.setImage(UIImage(named: self.picture.ImageName)?.resize(newWidth: 312), for: .normal)
        //editVC.editPicture.setTitle("", for: .normal)
        editVC.modalPresentationStyle = .overFullScreen
        self.dismiss(animated: false) {
            picVC.present(editVC, animated: false)
        }
    }
    @IBAction func zoomImage(_ sender: Any) {
        guard let zoomVC = self.storyboard?.instantiateViewController(withIdentifier: "ImageViewController") as? ImageViewController else { return }
        let totalPath = "\(self.picture.AlbumTitle)_\(self.picture.perAlbumIndex)"
        zoomVC.imageName = totalPath
        zoomVC.albumTitle = self.picture.AlbumTitle
        zoomVC.modalPresentationStyle = .overFullScreen
        self.present(zoomVC, animated: false)
    }
}
