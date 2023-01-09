import UIKit

class AlbumPicViewController: UIViewController {

    @IBOutlet weak var picName: UILabel!
    @IBOutlet weak var picText: UILabel!
    @IBOutlet weak var picImage: UIButton!
    var picture: album!
    override func viewDidLoad() {
        super.viewDidLoad()
        picName.text = picture.ImageName
        picText.text = picture.ImageText
        picImage.setTitle("", for: .normal)
        let totalPath = "\(picture.AlbumTitle)_\(picture.perAlbumIndex)"
        picImage.setImage(loadImageFromDocumentDirectory(imageName: totalPath, albumTitle: picture.AlbumTitle)?.resize(newWidth: 297), for: .normal)
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(exitSwipe(_:)))
        swipeRecognizer.direction = .down
        self.view.addGestureRecognizer(swipeRecognizer)
    }
    @objc func exitSwipe(_ sender :UISwipeGestureRecognizer){
        if sender.direction == .down{
            self.dismiss(animated: true)
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
