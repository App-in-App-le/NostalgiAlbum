import UIKit
import RealmSwift

class ImageViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var closeButton: UIButton!
    let realm = try! Realm()
    var imageName: String?
    var albumTitle: String?
    
    override func viewDidLoad() {
        scrollView.delegate = self
        closeButton.setTitle("", for: .normal)
        closeButton.setImage(UIImage(systemName: "clear"), for: .normal)
        imageInit()
        setThemeColor()
    }
    
    func imageInit() {
        imageView.image = loadImageFromDocumentDirectory(imageName: imageName!, albumTitle: albumTitle!)?.resize(width: imageView.frame.width, height: imageView.frame.height)
    }
    
    @IBAction func closeAction(_ sender: Any) {
        self.dismiss(animated: false)
    }
}

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
